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

module "container_registry_spa" {
  source = "./.."

  compartment_id = local.tenancy
  project_name   = local.project_name
  environment    = local.environment
  region         = "me-jeddah-1"
  suffix         = "spa"

  group_name_for_permission         = "${local.project_name}-${local.environment}-CICD"
  container_repository_is_immutable = false
  container_repository_is_public    = false
}

module "user" {
  source = "../../oracle-user"

  tenancy_ocid        = local.tenancy
  compartment_id      = local.tenancy
  environment         = local.environment
  user_name           = "${local.project_name}-${local.environment}-CICD"
  group_name          = "${local.project_name}-${local.environment}-CICD"
  create_auth_tokens  = true

  policy_name = "${local.project_name}-${local.environment}-access-to-cr"
  policy_statements = flatten([
    module.container_registry_api_php.policy,
    module.container_registry_spa.policy
  ])
}