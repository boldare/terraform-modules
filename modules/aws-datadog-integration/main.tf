/**
 * # AWS Datadog Integration
 * Creates lambda function, role & policies necessary to run full Datadog monitoring for AWS account.
 * Source code for Lambda can be found at [DataDog/datadog-serverless-functions](https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring) repository.
 */

locals {
  name               = "datadog-log-forwarder"
  archive_file       = "${path.module}/lambda.gen.zip"
  runtime            = "python3.7"
  layer_runtime      = "Python37"
  layer_version      = 11
  datadog_account_id = "464622532012"
  lambda_layer       = "arn:aws:lambda:${var.aws_region}:${local.datadog_account_id}:layer:Datadog-${local.layer_runtime}:${local.layer_version}"
}

# ----------------------------------------------------------------------------------------------------------------------
# IAM ROLE & POLICIES
# This gives Datadog all necessary read-only permissions to access logs
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "datadog" {
  statement {
    sid    = "Monitoring"
    effect = "Allow"
    actions = [
      "apigateway:GET",
      "autoscaling:Describe*",
      "budgets:ViewBudget",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codedeploy:List*",
      "codedeploy:BatchGet*",
      "directconnect:Describe*",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "ec2:Describe*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeTags",
      "elasticloadbalancing:Describe*",
      "elasticmapreduce:List*",
      "elasticmapreduce:Describe*",
      "es:ListTags",
      "es:ListDomainNames",
      "es:DescribeElasticsearchDomains",
      "health:DescribeEvents",
      "health:DescribeEventDetails",
      "health:DescribeAffectedEntities",
      "kinesis:List*",
      "kinesis:Describe*",
      "lambda:AddPermission",
      "lambda:GetPolicy",
      "lambda:List*",
      "lambda:RemovePermission",
      "logs:TestMetricFilter",
      "logs:PutSubscriptionFilter",
      "logs:DeleteSubscriptionFilter",
      "logs:DescribeSubscriptionFilters",
      "rds:Describe*",
      "rds:List*",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "route53:List*",
      "s3:GetBucketLogging",
      "s3:GetBucketLocation",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:PutBucketNotification",
      "ses:Get*",
      "sns:List*",
      "sns:Publish",
      "sqs:ListQueues",
      "support:*",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "datadog_monitoring" {
  name   = "datadog_monitoring"
  policy = data.aws_iam_policy_document.datadog.json
}

data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::464622532012:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        var.aws_account_external_id
      ]
    }
  }

}

resource "aws_iam_role" "datadog_integration" {
  name               = "datadog"
  assume_role_policy = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
}

resource "aws_iam_role_policy_attachment" "datadog_integration_monitoring" {
  policy_arn = aws_iam_policy.datadog_monitoring.arn
  role       = aws_iam_role.datadog_integration.id
}

# ----------------------------------------------------------------------------------------------------------------------
# DATADOG FORWARDER LAMBDA
# AWS Lambda function to ship logs and metrics from ELB, S3, CloudTrail, VPC, CloudFront and CloudWatch logs to Datadog.
# ----------------------------------------------------------------------------------------------------------------------

data "archive_file" "datadog_lambda" {
  output_path = local.archive_file
  type        = "zip"

  source {
    content  = file("${path.module}/lambda/lambda_function.py")
    filename = "lambda_function.py"
  }

  source {
    content  = file("${path.module}/lambda/enhanced_lambda_metrics.py")
    filename = "enhanced_lambda_metrics.py"
  }
}

data "aws_iam_policy_document" "datadog_write_logs" {
  # CloudWatch Logging
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "datadog_write_logs" {
  policy = data.aws_iam_policy_document.datadog_write_logs.json
  role   = aws_iam_role.datadog_lambda.id
}

data "aws_iam_policy_document" "datadog_lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "datadog_lambda" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.datadog_lambda.json
}

resource "aws_iam_role_policy_attachment" "datadog_lambda_monitoring" {
  policy_arn = aws_iam_policy.datadog_monitoring.arn
  role       = aws_iam_role.datadog_lambda.id
}

resource "aws_cloudwatch_log_group" "datadog" {
  name              = "/aws/lambda/${local.name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "datadog" {
  function_name = local.name
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.datadog_lambda.arn
  runtime       = "python3.7"
  filename      = local.archive_file
  layers = [
    local.lambda_layer
  ]

  memory_size                    = 1024
  timeout                        = 120
  reserved_concurrent_executions = 100

  environment {
    variables = {
      DD_API_KEY = var.api_key
      DD_SITE    = var.site
    }
  }
}
