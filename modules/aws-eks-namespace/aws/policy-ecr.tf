data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid = "RepositoryInfoAndCreation"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
      "ecr:CreateRepository"
    ]
    resources = ["*"]
  }
  statement {
    sid = "RepositoryAllAccess"
    effect = "Allow"
    actions = ["*"]
    resources = ["arn:aws:ecr:*:*:repository/${var.namespace_name}/*"]
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name = "${var.namespace_name}-ecr-policy"
  policy = data.aws_iam_policy_document.ecr_policy.json
}

data "aws_iam_policy_document" "ecr_read_policy" {
  statement {
    sid = "RepositoryInfo"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
    ]
    resources = ["*"]
  }
  statement {
    sid = "RepositoryReadAccess"
    effect = "Allow"
    actions = [
      "ecr:ListImages",
      "ecr:ListTagsForResource",
      "ecr:GetLifecyclePolicy",
      "ecr:DescribeImages"
    ]
    resources = ["arn:aws:ecr:*:*:repository/${var.namespace_name}/*"]
  }
}

resource "aws_iam_policy" "ecr_read_policy" {
  name = "${var.namespace_name}-ecr-read-policy"
  policy = data.aws_iam_policy_document.ecr_read_policy.json
}
