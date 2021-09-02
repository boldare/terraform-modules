locals {
  ecr_arns = length(var.ecr_arn_list) > 0 ? var.ecr_arn_list : ["arn:aws:ecr:*:*:repository/${var.namespace_name}/*"]
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid    = "RepositoryInfoAndCreation"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
      "ecr:CreateRepository"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "RepositoryAllAccess"
    effect    = "Allow"
    actions   = ["*"]
    resources = local.ecr_arns
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name   = "${var.namespace_name}-ecr-policy"
  policy = data.aws_iam_policy_document.ecr_policy.json
}

data "aws_iam_policy_document" "ecr_read_policy" {
  statement {
    sid    = "RepositoryInfo"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "RepositoryReadAccess"
    effect = "Allow"
    actions = [
      "ecr:ListImages",
      "ecr:ListTagsForResource",
      "ecr:GetLifecyclePolicy",
      "ecr:DescribeImages"
    ]
    resources = local.ecr_arns
  }
}

resource "aws_iam_policy" "ecr_read_policy" {
  name   = "${var.namespace_name}-ecr-read-policy"
  policy = data.aws_iam_policy_document.ecr_read_policy.json
}
