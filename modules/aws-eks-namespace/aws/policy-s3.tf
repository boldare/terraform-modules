data aws_iam_policy_document "s3_policy" {
  statement {
    sid       = "BucketInfo"
    effect    = "Allow"
    actions   = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "FullBucketAccess"
    effect    = "Allow"
    actions   = ["*"]
    resources = [
      "arn:aws:s3:::${var.namespace_name}-*",
      "arn:aws:s3:::${var.namespace_name}-*/*"
    ]
  }
}

resource "aws_iam_policy" "s3_policy" {
  name   = "${var.namespace_name}-s3-policy"
  policy = data.aws_iam_policy_document.s3_policy.json
}

data aws_iam_policy_document "s3_read_policy" {
  statement {
    sid       = "BucketInfo"
    effect    = "Allow"
    actions   = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "ReadOnlyAccess"
    effect    = "Allow"
    actions   = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:ListBucket",
      "s3:ListJobs"
    ]
    resources = [
      "arn:aws:s3:::${var.namespace_name}-*",
      "arn:aws:s3:::${var.namespace_name}-*/*"
    ]
  }
}

resource "aws_iam_policy" "s3_read_policy" {
  name   = "${var.namespace_name}-s3-read-policy"
  policy = data.aws_iam_policy_document.s3_read_policy.json
}
