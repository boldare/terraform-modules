output "id" {
  description = "ID of the container registry"
  value       = oci_artifacts_container_repository.terraform_container_registry.id
}
output "name" {
  description = "Name of the container registry"
  value       = oci_artifacts_container_repository.terraform_container_registry.display_name
}
output "url" {
  description = "url to push/pull containers to/from"
  value       = "${var.region}.ocir.io/${data.oci_objectstorage_namespace.namespace.namespace}/${oci_artifacts_container_repository.terraform_container_registry.display_name}"
}
output "policy" {
  description = "policies that allow push and pull to this container registry by user"
  value = [
    "Allow group ${var.group_name_for_permission} to read repos in compartment id ${var.compartment_id} where any { target.repo.name=/${oci_artifacts_container_repository.terraform_container_registry.display_name}*/}",
    "Allow group ${var.group_name_for_permission} to use repos in compartment id ${var.compartment_id} where any { target.repo.name=/${oci_artifacts_container_repository.terraform_container_registry.display_name}*/}",
    "Allow group ${var.group_name_for_permission} to manage repos in compartment id ${var.compartment_id} where any { target.repo.name=/${oci_artifacts_container_repository.terraform_container_registry.display_name}*/}",
  ]
}
