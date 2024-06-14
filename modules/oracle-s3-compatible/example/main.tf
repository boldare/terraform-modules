locals {
  tenancy = "ocid1.tenancy.oc1..aaaaaaaa1111111111111111111111111111111111111111111111111111"
}
provider "oci" {
  tenancy_ocid        = local.tenancy
  config_file_profile = "boldare"
}

module "private-s3" {
  source         = "./.."
  compartment_id = local.tenancy
  environment    = "dev"
  project_name   = "my-project"
  tenancy_ocid   = local.tenancy
  region         = "me-jeddah-1"
  public_access  = false
}

module "public-s3" {
  source         = "./.."
  compartment_id = local.tenancy
  environment    = "dev"
  project_name   = "my-project-public"
  tenancy_ocid   = local.tenancy
  region         = "me-jeddah-1"
  public_access  = true
}