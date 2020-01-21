data "aws_caller_identity" "current" {}

locals {
  aws_account_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}

# ----------------------------------------------------------------------------------------------------------------------
# KMS KEY
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [local.aws_account_arn]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = concat(var.key_admin_arns, [local.aws_account_arn])
    }

    actions   = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = concat(var.key_user_arns, [local.aws_account_arn])
    }

    actions   = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = concat(var.key_user_arns, [local.aws_account_arn])
    }

    actions   = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "kms:GrantIsForAWSResource"
    }
  }
}

resource "aws_kms_key" "this" {
  is_enabled  = var.is_enabled
  description = var.description
  policy      = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "this" {
  target_key_id = aws_kms_key.this.key_id
  name          = "alias/${var.alias_name}"
}

# ----------------------------------------------------------------------------------------------------------------------
# USER IAM POLICY
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "iam_user" {
  statement {
    sid       = "AllowKeyUsage"
    effect    = "Allow"
    actions   = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.this.arn]
  }
  statement {
    sid       = "AllowPersistentResourcesAttachment"
    effect    = "Allow"
    actions   = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = [aws_kms_key.this.arn]
    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "kms:GrantIsForAWSResource"
    }
  }
}

resource "aws_iam_policy" "user" {
  name_prefix = "${var.alias_name}-kms-key-user"
  policy      = data.aws_iam_policy_document.iam_user.json
}

# ----------------------------------------------------------------------------------------------------------------------
# ADMIN IAM POLICY
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "iam_admin" {

  statement {
    sid       = "AllowKeyUsage"
    effect    = "Allow"
    actions   = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = [aws_kms_key.this.arn]
  }
}

resource "aws_iam_policy" "admin" {
  name_prefix = "${var.alias_name}-kms-key-admin"
  policy      = data.aws_iam_policy_document.iam_admin.json
}
