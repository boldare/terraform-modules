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
      "arn:aws:iam::*:user/${var.authorization_policy_path_prefix}$${aws:username}",
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
      "arn:aws:iam::*:user/${var.authorization_policy_path_prefix}$${aws:username}"
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
      "arn:aws:iam::*:mfa/${var.authorization_policy_path_prefix}$${aws:username}",
      "arn:aws:iam::*:user/${var.authorization_policy_path_prefix}$${aws:username}"
    ]
  }

  statement {
    sid       = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"
    effect    = "Allow"
    actions   = [
      "iam:DeactivateMFADevice"
    ]
    resources = [
      "arn:aws:iam::*:mfa/${var.authorization_policy_path_prefix}$${aws:username}",
      "arn:aws:iam::*:user/${var.authorization_policy_path_prefix}$${aws:username}"
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
  name        = var.name
  description = "MFA authorization policy applicable for all human users."
  policy      = data.aws_iam_policy_document.authorization.json
}
