/**
 * # AWS Cert Lambda
 * AWS Cert Lambda module creates infrastructure that provides certificates for a domain in a Route53 zone.
 * Certificates are stored on S3 bucket (encrypted by KMS key) and are verified using DNS method.
 * It is based on `certbot` and `letsencrypt.org`. CloudWatch events are used to trigger lambda according
 * to `refresh_frequency_cron` (once every 12 hours by default).
 */

locals {
  requirements_archive = "${path.module}/src/requirements.zip"
  script_archive       = "${path.module}/files/certbot.gen.zip"
  function_name        = "${var.name_prefix}-certbot-domain-refresh"
}

data "archive_file" "certbot" {
  type        = "zip"
  output_path = local.script_archive

  source {
    content  = file("${path.module}/src/main.py")
    filename = "main.py"
  }
}

resource "aws_lambda_layer_version" "certbot_requirements" {
  layer_name = "${var.name_prefix}-certbot-domain-refresh-requirements"

  filename            = local.requirements_archive
  source_code_hash    = filebase64sha256(local.requirements_archive)
  compatible_runtimes = ["python3.7"]
}

resource "aws_lambda_function" "certbot" {
  depends_on = [aws_cloudwatch_log_group.certbot]

  filename      = data.archive_file.certbot.output_path
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  handler       = "main.lambda_handler"
  layers = [
    aws_lambda_layer_version.certbot_requirements.id
  ]

  source_code_hash = data.archive_file.certbot.output_base64sha256

  runtime = "python3.7"
  timeout = 5 * 60

  environment {
    variables = {
      EMAIL     = var.owner_email
      DOMAINS   = join(",", var.domain_names)
      S3_BUCKET = var.s3_bucket_name
      S3_PREFIX = var.s3_bucket_prefix
    }
  }
}

resource "aws_cloudwatch_log_group" "certbot" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 14
}

# ---------------------------------------------------------------------------------------------------------------------
# Lambda CRON Events
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "certbot" {
  name                = "${var.name_prefix}-certbot-timer"
  schedule_expression = "cron(${var.refresh_frequency_cron})"
}

resource "aws_cloudwatch_event_target" "certbot" {
  rule = aws_cloudwatch_event_rule.certbot.name
  arn  = aws_lambda_function.certbot.arn
}

resource "aws_lambda_permission" "permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.certbot.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.certbot.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# Lambda Permissions
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "lambda" {
  # CloudWatch Logging
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
  # Route53 DNS changes
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:GetChange"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
    ]
  }
  # S3 Bucket Access
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
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:HeadObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
  }
}

resource "aws_iam_policy" "lambda" {
  policy = data.aws_iam_policy_document.lambda.json
}

data "aws_iam_policy_document" "lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.name_prefix}-certbot-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = aws_iam_policy.lambda.arn
  role       = aws_iam_role.lambda.id
}
