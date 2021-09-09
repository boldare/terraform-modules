/**
 * # Oracle user
 * Simple module creating user and creating policies.
 */


resource "oci_identity_user" "terraform_user" {
  compartment_id = var.tenancy_ocid
  description    = var.user_description
  name           = var.user_name

  freeform_tags = { "environment" = var.environment }
}

resource "oci_identity_group" "terraform_user_group" {
  compartment_id = var.tenancy_ocid
  description    = var.group_description
  name           = var.group_name

  freeform_tags = { "environment" = var.environment }
}

resource "oci_identity_policy" "terraform_policy" {
  compartment_id = var.compartment_id
  description    = var.policy_description
  name           = var.policy_name
  statements     = var.policy_statements

  freeform_tags = { "environment" = var.environment, "user" = oci_identity_user.terraform_user.name, "group" = oci_identity_group.terraform_user_group.name }
}

resource "oci_identity_user_group_membership" "terraform_user_group_membership" {
  group_id = oci_identity_group.terraform_user_group.id
  user_id  = oci_identity_user.terraform_user.id
}

resource "oci_identity_user_capabilities_management" "terraform_user" {
  user_id = oci_identity_user.terraform_user.id

  can_use_api_keys             = var.allow_api_key
  can_use_auth_tokens          = var.create_auth_tokens
  can_use_console_password     = var.can_use_console_password
  can_use_customer_secret_keys = var.create_customer_secret_key
  can_use_smtp_credentials     = var.create_smtp_credentials
}

resource "oci_identity_api_key" "terraform_user_api_keys" {
  count     = var.set_api_key ? 1 : 0
  key_value = var.api_rsa_keys
  user_id   = oci_identity_user.terraform_user.id
}

resource "oci_identity_auth_token" "terraform_user_auth_token" {
  count       = var.create_auth_tokens ? 1 : 0
  description = var.tokens_description
  user_id     = oci_identity_user.terraform_user.id
}

resource "oci_identity_customer_secret_key" "terraform_user_secret_keys" {
  count        = var.create_customer_secret_key ? 1 : 0
  display_name = var.tokens_description
  user_id      = oci_identity_user.terraform_user.id
}

resource "oci_identity_smtp_credential" "terraform_user_smtp_credentials" {
  count       = var.create_smtp_credentials ? 1 : 0
  user_id     = oci_identity_user.terraform_user.id
  description = var.tokens_description
}
