/**
 * # AWS Cognito
 * This module provides AWS Cognito User Pool in which SMS & e-mail settings are
 * configured to opinionated reasonable defaults. One can specify message templates
 * and attributes that can be included in Cognito database.
 * An IAM policy for managing pool is provided as an output.
 */

resource "random_uuid" "cognito_external_id" {}

# ----------------------------------------------------------------------------------------------------------------------
# COGNITO USER POOL
# Uses e-mail by default
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_cognito_user_pool" "pool" {
  name = var.name

  mfa_configuration = var.mfa_configuration

  alias_attributes = [
    "email"
  ]
  auto_verified_attributes = [
    "email"
  ]

  password_policy {
    temporary_password_validity_days = 7
  }

  sms_authentication_message = var.sms_authentication_message

  email_configuration {
    email_sending_account  = "DEVELOPER"
    reply_to_email_address = var.email_reply
    source_arn             = var.email_source_arn
  }

  admin_create_user_config {
    allow_admin_create_user_only = var.allow_admin_create_user_only

    invite_message_template {
      email_message = var.email_invitation_message
      email_subject = var.email_invitation_subject
      sms_message   = var.sms_invitation_message
    }
  }

  device_configuration {
    challenge_required_on_new_device      = false
    device_only_remembered_on_user_prompt = true
  }

  verification_message_template {
    default_email_option  = var.default_email_option
    sms_message           = var.sms_verification_message
    email_message         = var.email_verification_message
    email_message_by_link = var.email_verification_message_by_link
    email_subject         = var.email_verification_subject
    email_subject_by_link = var.email_verification_subject_by_link
  }

  sms_configuration {
    external_id    = random_uuid.cognito_external_id.id
    sns_caller_arn = aws_iam_role.sms_role.arn
  }

  password_policy {
    minimum_length    = var.password_policy.minimum_length
    require_lowercase = var.password_policy.require_lowercase
    require_numbers   = var.password_policy.require_numbers
    require_symbols   = var.password_policy.require_symbols
    require_uppercase = var.password_policy.require_uppercase
  }

  dynamic "schema" {
    for_each = var.attributes

    content {
      name                     = schema.value.name
      attribute_data_type      = schema.value.type
      required                 = schema.value.required
      mutable                  = schema.value.mutable
      developer_only_attribute = schema.value.developer_only_attribute

      dynamic "number_attribute_constraints" {
        for_each = schema.value.type == "Number" ? [schema.value.constraints] : []

        content {
          min_value = number_attribute_constraints.value.min_value
          max_value = number_attribute_constraints.value.max_value
        }
      }

      dynamic "string_attribute_constraints" {
        for_each = schema.value.type == "String" ? [schema.value.constraints] : []

        content {
          min_length = string_attribute_constraints.value.min_value
          max_length = string_attribute_constraints.value.max_value
        }
      }
    }
  }

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# USER POOL IAM POLICY
# This policy can be applied to roles and user which will manage User Pool.
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "user_pool" {
  statement {
    sid       = "UserPoolOperations"
    effect    = "Allow"
    actions   = ["cognito-idp:*"]
    resources = [aws_cognito_user_pool.pool.arn]
  }
}

resource "aws_iam_policy" "user_pool" {
  name   = "${var.name}-operations"
  policy = data.aws_iam_policy_document.user_pool.json
}

# ----------------------------------------------------------------------------------------------------------------------
# SMS IAM CONFIGURATION
# Definition of an IAM role and it's permissions, that allow sending text messages by Cognito.
# It can be used to verify phone numbers etc.
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "sms_role_assume_role" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["cognito-idp.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      values   = [random_uuid.cognito_external_id.id]
      variable = "sts:ExternalId"
    }
  }
}

data "aws_iam_policy_document" "sms_cognito_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sns:publish"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "sms_role" {
  name               = "${var.name}-sms-role"
  assume_role_policy = data.aws_iam_policy_document.sms_role_assume_role.json
}

resource "aws_iam_role_policy" "sms_cognito_policy" {
  policy = data.aws_iam_policy_document.sms_cognito_policy.json
  role   = aws_iam_role.sms_role.id
}
