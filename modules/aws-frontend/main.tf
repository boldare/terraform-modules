/**
 * # AWS Frontend
 *
 * This module creates complete environment for frontend applications:
 * - S3 bucket to store SPA files
 * - CloudFront distribution to ensure fast access and caching
 * - Lambda@Edge to ensure proper CORS headers
 * - ACM certificate for HTTPS (created via `aws.global` provider)
 * - Route53 entries to set user-friendly domain (created via `aws.hosted_zone` provider)
 *
 * You may want to set custom providers to deploy some parts of frontend:
 * - S3 bucket & IAM policies is deployed using the default `aws` provider
 * - Lambda@Edge & ACM certificate have to be created on `us-east-1` region (via `aws.global` provider),
 * - Route53 entries can be on a different AWS account (via `aws.hosted_zone` provider)
 */

provider "aws" {
  alias = "global"
}

provider "aws" {
  alias = "hosted_zone"
}


# ----------------------------------------------------------------------------------------------------------------------
# S3 BUCKET STORING FRONTEND APP
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  acl    = "private"
  versioning {
    enabled = true
  }

  tags = var.tags
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3.iam_arn]
    }
  }
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.bucket.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# ----------------------------------------------------------------------------------------------------------------------
# ACM CERTIFICATE FOR FRONTEND DOMAIN
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = var.alternative_domain_names
  validation_method         = "DNS"
  tags                      = var.tags

  provider = aws.global
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = aws_route53_record.certificate_validation.*.fqdn

  provider = aws.global
}

resource "aws_route53_record" "certificate_validation" {
  count = length(var.alternative_domain_names)+1

  name    = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_type
  zone_id = var.hosted_zone_id
  records = [aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_value]
  ttl     = 60

  provider = aws.hosted_zone
}

# ----------------------------------------------------------------------------------------------------------------------
# CLOUDFRONT DISTRIBUTION
# ----------------------------------------------------------------------------------------------------------------------

locals {
  allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods         = ["GET", "HEAD"]
  viewer_protocol_policy = "redirect-to-https"
  s3_origin              = random_pet.s3_origin.id
  domains                = concat([var.domain_name], var.alternative_domain_names)
}

resource "random_pet" "s3_origin" {}

resource "aws_cloudfront_origin_access_identity" "s3" {
  comment = var.comment
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  http_version        = "http2"
  aliases             = local.domains
  tags                = var.tags
  comment             = var.comment
  price_class         = "PriceClass_All"
  wait_for_deployment = var.wait_for_deployment
  web_acl_id          = var.web_acl_id

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_domain_name
    origin_id   = local.s3_origin

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = local.allowed_methods
    cached_methods         = local.cached_methods
    viewer_protocol_policy = local.viewer_protocol_policy
    target_origin_id       = local.s3_origin
    compress               = true

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "viewer-response"
      lambda_arn = local.lambda_arn
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.cache_disabled_path_patterns
    content {
      path_pattern           = ordered_cache_behavior.value
      allowed_methods        = local.allowed_methods
      cached_methods         = local.cached_methods
      viewer_protocol_policy = local.viewer_protocol_policy
      target_origin_id       = local.s3_origin
      compress               = true

      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 0

      forwarded_values {
        query_string = false
        cookies {
          forward = "none"
        }
      }

      lambda_function_association {
        event_type = "viewer-response"
        lambda_arn = local.lambda_arn
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.certificate_validation.certificate_arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
    error_caching_min_ttl = 30
  }
}

resource "aws_route53_record" "distribution" {
  count = length(local.domains)

  name    = local.domains[count.index]
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
  }

  provider = aws.hosted_zone
}

# ----------------------------------------------------------------------------------------------------------------------
# LAMBDA@EDGE
# Ensures correct Content-Security-Policy, Strict-Transport-Security headers and more.
# ----------------------------------------------------------------------------------------------------------------------

locals {
  lambda_archive = "${path.module}/lambda.zip"
  lambda_arn     = aws_lambda_function.edge_lambda.qualified_arn
}

data "template_file" "edge_lambda" {
  template = file("${path.module}/lambda.js")
  vars     = {
    csp_json_string = jsonencode(var.content_security_policy)
    header_frame_options = var.header_frame_options
  }
}

data "archive_file" "edge_lambda" {
  type                    = "zip"
  source_content          = data.template_file.edge_lambda.rendered
  source_content_filename = "index.js"
  output_path             = local.lambda_archive
}

resource "aws_cloudwatch_log_group" "edge_lambda" {
  name              = "/aws/lambda/${var.name}-lambda-edge"
  retention_in_days = 14
}

resource "aws_lambda_function" "edge_lambda" {
  function_name    = "${var.name}-lambda-edge"
  handler          = "index.handler"
  role             = aws_iam_role.edge_lambda.arn
  runtime          = "nodejs12.x"
  timeout          = 5
  filename         = data.archive_file.edge_lambda.output_path
  source_code_hash = data.archive_file.edge_lambda.output_base64sha256
  publish          = true
  tags             = var.tags

  provider = aws.global
}

# ----------------------------------------------------------------------------------------------------------------------
# LAMBDA@EDGE IAM PERMISSIONS
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "edge_lambda" {
  # CloudWatch Logging
  statement {
    effect    = "Allow"
    actions   = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "edge_lambda" {
  policy = data.aws_iam_policy_document.edge_lambda.json
}

data "aws_iam_policy_document" "edge_lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "edge_lambda" {
  name               = "${var.name}-lambda-edge-role"
  assume_role_policy = data.aws_iam_policy_document.edge_lambda_role.json
}

resource "aws_iam_role_policy_attachment" "edge_lambda" {
  policy_arn = aws_iam_policy.edge_lambda.arn
  role       = aws_iam_role.edge_lambda.id
}

# ----------------------------------------------------------------------------------------------------------------------
# IAM DEPLOYER POLICY
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "deployer" {
  statement {
    effect    = "Allow"
    actions   = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.bucket.arn]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deployer" {
  name   = "${var.name}-deployer"
  policy = data.aws_iam_policy_document.deployer.json
}
