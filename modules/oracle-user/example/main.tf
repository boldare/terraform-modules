locals {
  tenancy = "ocid1.tenancy.oc1..aaaaaaaa1111111111111111111111111111111111111111111111111111"
}
provider "oci" {
  tenancy_ocid        = local.tenancy
  config_file_profile = "boldare"
}

module "user" {
  source            = "./.."
  compartment_id    = local.tenancy
  environment       = "dev"
  group_name        = "helpdesk"
  policy_name       = "policy-for-helpdesk"
  policy_statements = ["Allow group helpdesk to manage users in tenancy"]
  tenancy_ocid      = local.tenancy
  user_name         = "foo.bar"

  create_auth_tokens         = true
  create_customer_secret_key = true
  create_smtp_credentials    = true
}

output "user" {
  value = module.user
}
