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
 *
 * If you wish to gracefully destroy this module, make sure to set `scheduled_for_deletion` parameter to `true`.
 * Otherwise you won't be able to remove non-empty S3 bucket or Lambda@Edge functions still connected to CloudFront.
 * Setting this flag to `true` may render your environment unusable, so make sure to migrate gracefully to a different
 * environment by provisioning replacement and swapping DNS entries first.
 */

provider "aws" {
  version = "~>3.0"
  alias   = "global"
}

provider "aws" {
  version = "~>3.0"
  alias   = "hosted_zone"
}

# ----------------------------------------------------------------------------------------------------------------------
# S3 BUCKET STORING FRONTEND APP
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "bucket" {
  count = var.enabled ? 1 : 0

  bucket = var.name
  acl    = "private"

  force_destroy = var.scheduled_for_deletion

  tags = var.tags
}

data "aws_iam_policy_document" "s3_policy" {
  count = var.enabled ? 1 : 0

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket[0].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3[0].iam_arn]
    }
  }
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.bucket[0].arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3[0].iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  count = var.enabled ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  policy = data.aws_iam_policy_document.s3_policy[0].json
}

# ----------------------------------------------------------------------------------------------------------------------
# ACM CERTIFICATE FOR FRONTEND DOMAIN
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_acm_certificate" "certificate" {
  count = var.enabled ? 1 : 0

  domain_name               = var.domain_name
  subject_alternative_names = var.alternative_domain_names
  validation_method         = "DNS"
  tags                      = var.tags

  provider = aws.global
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  count = var.enabled ? 1 : 0

  certificate_arn = aws_acm_certificate.certificate[0].arn
  validation_record_fqdns = [
    for validation in aws_route53_record.certificate_validation :
    validation.fqdn
  ]

  provider = aws.global
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in(length(aws_acm_certificate.certificate) > 0 ? aws_acm_certificate.certificate[0].domain_validation_options : toset([])) : dvo["domain_name"] => {
      name   = dvo["resource_record_name"]
      record = dvo["resource_record_value"]
      type   = dvo["resource_record_type"]
    }
  }

  name    = each.value["name"]
  type    = each.value["type"]
  zone_id = var.hosted_zone_id
  records = [each.value["record"]]
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
  s3_origin              = var.enabled ? random_pet.s3_origin[0].id : ""
  domains                = concat([var.domain_name], var.alternative_domain_names)
}

resource "random_pet" "s3_origin" {
  count = var.enabled ? 1 : 0
}

resource "aws_cloudfront_origin_access_identity" "s3" {
  count = var.enabled ? 1 : 0

  comment = var.comment
}

resource "aws_cloudfront_distribution" "distribution" {
  count = var.enabled ? 1 : 0

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
    domain_name = aws_s3_bucket.bucket[0].bucket_regional_domain_name
    origin_id   = local.s3_origin

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3[0].cloudfront_access_identity_path
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

    dynamic "lambda_function_association" {
      for_each = local.headers_edge_function

      content {
        event_type = "viewer-response"
        lambda_arn = local.headers_lambda_arn
      }
    }

    dynamic "lambda_function_association" {
      for_each = local.enabled_edge_functions

      content {
        event_type   = lambda_function_association.value["event_type"]
        lambda_arn   = aws_lambda_function.edge_lambda_custom[lambda_function_association.key].qualified_arn
        include_body = lambda_function_association.value["include_body"]
      }
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

      dynamic "lambda_function_association" {
        for_each = local.headers_edge_function

        content {
          event_type = "viewer-response"
          lambda_arn = local.headers_lambda_arn
        }
      }

      dynamic "lambda_function_association" {
        for_each = local.enabled_edge_functions

        content {
          event_type   = lambda_function_association.value["event_type"]
          lambda_arn   = aws_lambda_function.edge_lambda_custom[lambda_function_association.key].qualified_arn
          include_body = lambda_function_association.value["include_body"]
        }
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.certificate_validation[0].certificate_arn
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
  count = var.enabled && var.create_distribution_dns_records ? length(local.domains) : 0

  name    = local.domains[count.index]
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.distribution[0].domain_name
    zone_id                = aws_cloudfront_distribution.distribution[0].hosted_zone_id
  }

  provider = aws.hosted_zone
}

# ----------------------------------------------------------------------------------------------------------------------
# HEADERS LAMBDA@EDGE
# Ensures correct Content-Security-Policy, Strict-Transport-Security headers and more.
# ----------------------------------------------------------------------------------------------------------------------

locals {
  lambda_functions_dir = "${path.module}/lambda-functions"
  headers_lambda_arn   = var.enabled ? aws_lambda_function.edge_lambda[0].qualified_arn : ""
}

data "template_file" "edge_lambda" {
  count = var.enabled ? 1 : 0

  template = file("${local.lambda_functions_dir}/headers.js")
  vars = {
    csp_json_string = jsonencode(var.content_security_policy)
    custom_headers_json_string = jsonencode({
      for key, value in var.custom_headers : lower(key) => value
    })
  }
}

data "archive_file" "edge_lambda" {
  count = var.enabled ? 1 : 0

  type                    = "zip"
  source_content          = data.template_file.edge_lambda[0].rendered
  source_content_filename = "index.js"
  output_path             = "${local.lambda_functions_dir}/headers_archive.gen.zip"
}

resource "aws_cloudwatch_log_group" "edge_lambda" {
  count = var.enabled ? 1 : 0

  name              = "/aws/lambda/${var.name}-lambda-edge"
  retention_in_days = var.lambda_log_retention_in_days
}

resource "aws_lambda_function" "edge_lambda" {
  count = var.enabled ? 1 : 0

  function_name    = "${var.name}-lambda-edge"
  handler          = "index.handler"
  role             = aws_iam_role.edge_lambda[0].arn
  runtime          = "nodejs12.x"
  timeout          = 5
  filename         = data.archive_file.edge_lambda[0].output_path
  source_code_hash = data.archive_file.edge_lambda[0].output_base64sha256
  publish          = true
  tags             = var.tags

  provider = aws.global
}

# ----------------------------------------------------------------------------------------------------------------------
# ADDITIONAL LAMBDA@EDGE FUNCTIONS
# Custom Lambda functions attached to CloudFront.
# ----------------------------------------------------------------------------------------------------------------------
locals {
  headers_edge_function = var.enabled && ! var.scheduled_for_deletion ? {
    headers = "headers"
  } : {}
  enabled_edge_functions = var.enabled && ! var.scheduled_for_deletion ? var.edge_functions : {}
}

data "archive_file" "edge_lambda_custom" {
  for_each = local.enabled_edge_functions

  type                    = "zip"
  source_content          = each.value["lambda_code"]
  source_content_filename = "index.js"
  output_path             = "${local.lambda_functions_dir}/${each.key}_archive.gen.zip"
}

resource "aws_cloudwatch_log_group" "edge_lambda_custom" {
  for_each = local.enabled_edge_functions

  name              = "/aws/lambda/${var.name}-lambda-edge-${each.key}"
  retention_in_days = var.lambda_log_retention_in_days
}

resource "aws_lambda_function" "edge_lambda_custom" {
  for_each = local.enabled_edge_functions

  function_name    = "${var.name}-lambda-edge-${each.key}"
  handler          = "index.handler"
  role             = aws_iam_role.edge_lambda_custom[each.key].arn
  runtime          = each.value["lambda_runtime"]
  timeout          = 5
  filename         = data.archive_file.edge_lambda_custom[each.key].output_path
  source_code_hash = data.archive_file.edge_lambda_custom[each.key].output_base64sha256
  publish          = true
  tags             = var.tags

  provider = aws.global
}


# ----------------------------------------------------------------------------------------------------------------------
# LAMBDA@EDGE IAM PERMISSIONS
# ----------------------------------------------------------------------------------------------------------------------

locals {
  lambda_basic_policy = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "edge_lambda_role" {
  count = var.enabled ? 1 : 0

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
  count = var.enabled ? 1 : 0

  name               = "${var.name}-lambda-edge-role"
  assume_role_policy = data.aws_iam_policy_document.edge_lambda_role[0].json
}

resource "aws_iam_role" "edge_lambda_custom" {
  for_each = local.enabled_edge_functions

  name               = "${var.name}-${each.key}-lambda-edge-role"
  assume_role_policy = data.aws_iam_policy_document.edge_lambda_role[0].json
}

resource "aws_iam_role_policy_attachment" "edge_lambda" {
  count = var.enabled ? 1 : 0

  policy_arn = local.lambda_basic_policy
  role       = aws_iam_role.edge_lambda[0].id
}

resource "aws_iam_role_policy_attachment" "edge_lambda_custom" {
  for_each = local.enabled_edge_functions

  role       = aws_iam_role.edge_lambda_custom[each.key].id
  policy_arn = local.lambda_basic_policy
}

# ----------------------------------------------------------------------------------------------------------------------
# IAM DEPLOYER POLICY
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "deployer" {
  count = var.enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.bucket[0].arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.bucket[0].arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deployer" {
  count = var.enabled ? 1 : 0

  name   = "${var.name}-deployer"
  policy = data.aws_iam_policy_document.deployer[0].json
}
