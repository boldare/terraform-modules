terraform {
  required_providers {
    aws = "~>4.0"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ses_email_identity" "sender" {
  email = "no-reply@boldare.com"
}

module "cognito" {
  source = "../.."

  name = "boldare"

  email_source_arn = aws_ses_email_identity.sender.arn
  email_reply      = "no-reply@boldare.com"

  attributes = [
    {
      name                     = "email"
      type                     = "String"
      required                 = true
      mutable                  = true
      developer_only_attribute = false
      constraints = {
        min_value = "0"
        max_value = "2048"
      }
    },
    {
      name                     = "magical_id"
      type                     = "Number"
      required                 = false
      mutable                  = true
      developer_only_attribute = false
      constraints = {
        min_value = "1"
        max_value = "99999999999"
      }
    }
  ]

  tags = {
    Envrionment = "dev"
  }

  email_verification_message = "Your verification code is for this awesome bldr project is {####}."

  email_invitation_message = "Your username is {username} and temporary password is {####}."

  mfa_configuration            = "OFF"
  allow_admin_create_user_only = "false"

  password_policy = {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# COGNITO CLIENT APPS
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_cognito_user_pool_client" "backend" {
  name                   = "boldare-project-backend"
  user_pool_id           = module.cognito.user_pool_id
  generate_secret        = true
  refresh_token_validity = 30

  explicit_auth_flows           = local.auth_flows
  read_attributes               = local.all_attributes
  write_attributes              = local.client_write_attributes
  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_pool_client" "deskto_app" {
  name                   = "boldare-project-desktop"
  user_pool_id           = module.cognito.user_pool_id
  generate_secret        = false
  refresh_token_validity = 30

  explicit_auth_flows           = local.auth_flows
  read_attributes               = local.all_attributes
  write_attributes              = local.client_write_attributes
  prevent_user_existence_errors = "ENABLED"
}

locals {
  auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]

  all_attributes = [
    "address",
    "birthdate",
    "custom:crs_id",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
    "email_verified",
    "phone_number_verified"
  ]

  client_write_attributes = [
    "address",
    "birthdate",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "email",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "custom:crs_id",
    "updated_at",
    "website",
    "zoneinfo",
  ]
}
