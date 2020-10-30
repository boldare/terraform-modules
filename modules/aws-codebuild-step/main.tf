/**
 * # AWS codebuild step
 * AWS codebuild step is very simple module for creating CodeBuild project using just one object in terraform.
 * This module creates roles and codebuild project.
 */

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "task_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name = "${var.project_name}-role"

  assume_role_policy = data.aws_iam_policy_document.task_assume.json
}

data "aws_iam_policy_document" "task" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.project_name}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.project_name}:*"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["${var.artifact_s3_arn}/*"]
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:report-group/${var.project_name}-*"
    ]
  }
}


resource "aws_iam_role_policy" "role_policy" {
  role   = aws_iam_role.role.name
  policy = data.aws_iam_policy_document.task.json
}

resource "aws_codebuild_project" "project" {
  name          = var.project_name
  description   = var.description
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.role.arn

  artifacts {
    name = var.project_name
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.compute_size
    image                       = var.build_image
    type                        = var.compute_type
    image_pull_credentials_type = "CODEBUILD"
    dynamic "environment_variable" {
      for_each = var.environment_variables

      content {
        name  = environment_variable.value["name"]
        value = environment_variable.value["value"]
      }
    }
  }

  source {
    buildspec = var.buildspec_path
    type      = "CODEPIPELINE"
  }

  tags = var.tags
}
