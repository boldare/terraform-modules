# ----------------------------------------------------------------------------------------------------------------------
# Minimal recommended password policy
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_account_password_policy" "long-passwords" {
  minimum_password_length        = var.minimum_password_length
  require_lowercase_characters   = var.use_various_characters
  require_numbers                = var.use_various_characters
  require_uppercase_characters   = var.use_various_characters
  require_symbols                = var.use_various_characters
  allow_users_to_change_password = true
  max_password_age               = var.max_password_age
  password_reuse_prevention      = 3
}

# ----------------------------------------------------------------------------------------------------------------------
# FORCE MFA
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "authorization" {
  statement {
    sid       = "AllowPasswordSelfManagement"
    effect    = "Allow"
    actions   = [
      "iam:ChangePassword",
      "iam:UpdateUser",
      "iam:*AccessKey*",
      "iam:GetUser",
      "iam:*ServiceSpecificCredential*",
      "iam:*SigningCertificate*"
    ]
    resources = [
      "arn:aws:iam::*:user/$${aws:username}",
    ]
  }

  statement {
    sid       = "AllowListActions"
    effect    = "Allow"
    actions   = [
      "iam:ListUsers",
      "iam:ListVirtualMFADevices"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "AllowIndividualUserToListOnlyTheirOwnMFA"
    effect    = "Allow"
    actions   = [
      "iam:ListMFADevices"
    ]
    resources = [
      "arn:aws:iam::*:mfa/*",
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid       = "AllowIndividualUserToManageTheirOwnMFA"
    effect    = "Allow"
    actions   = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice"
    ]
    resources = [
      "arn:aws:iam::*:mfa/$${aws:username}",
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  statement {
    sid       = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"
    effect    = "Allow"
    actions   = [
      "iam:DeactivateMFADevice"
    ]
    resources = [
      "arn:aws:iam::*:mfa/$${aws:username}",
      "arn:aws:iam::*:user/$${aws:username}"
    ]
    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }

  statement {
    sid         = "BlockMostAccessUnlessSignedInWithMFA"
    effect      = "Deny"
    not_actions = [
      "iam:ChangePassword",
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ListMFADevices",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice"
    ]
    resources   = ["*"]
    condition {
      test     = "BoolIfExists"
      values   = ["false"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }
}

resource "aws_iam_policy" "authorization" {
  name        = "AuthorizationPolicy"
  description = "Authorization policy applicable for all human users."
  policy      = data.aws_iam_policy_document.authorization.json
}
