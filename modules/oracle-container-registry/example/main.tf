locals {
  tenancy      = "ocid1.tenancy.oc1..aaaaaaaa1111111111111111111111111111111111111111111111111111"
  project_name = "foo"
  environment  = "dev"
}

provider "oci" {
  tenancy_ocid        = local.tenancy
  config_file_profile = "boldare"
}
module "container_registry_api_php" {
  source = "./.."

  compartment_id = local.tenancy
  project_name   = local.project_name
  environment    = local.environment
  region         = "me-jeddah-1"
  suffix         = "api"

  group_name_for_permission         = "${local.project_name}-${local.environment}-CICD"
  container_repository_is_immutable = false
  container_repository_is_public    = false
}
