/**
 * # Oracle Cloud container repository with permissions
 * Very simple module that main purpose is to generate permissions and output docker urls in easy format for later use.
 */

locals {
  cr_name = "${var.project_name}-${var.environment}-${var.suffix}"
}
data "oci_objectstorage_namespace" "namespace" {
  compartment_id = var.compartment_id
}

resource "oci_artifacts_container_repository" "terraform_container_registry" {
  compartment_id = var.compartment_id
  display_name   = local.cr_name

  is_immutable = var.container_repository_is_immutable
  is_public    = var.container_repository_is_public
}
