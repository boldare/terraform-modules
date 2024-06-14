# Oracle Cloud container repository with permissions
Very simple module that main purpose is to generate permissions and output docker urls in easy format for later use.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_artifacts_container_repository.terraform_container_registry](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/artifacts_container_repository) | resource |
| [oci_objectstorage_namespace.namespace](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/objectstorage_namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment ID in which to create container registry. | `string` | n/a | yes |
| <a name="input_container_repository_is_immutable"></a> [container\_repository\_is\_immutable](#input\_container\_repository\_is\_immutable) | Whether the repository is immutable. Images cannot be overwritten in an immutable repository. | `bool` | `false` | no |
| <a name="input_container_repository_is_public"></a> [container\_repository\_is\_public](#input\_container\_repository\_is\_public) | Whether the repository is public. A public repository allows unauthenticated access. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. | `string` | n/a | yes |
| <a name="input_group_name_for_permission"></a> [group\_name\_for\_permission](#input\_group\_name\_for\_permission) | Used only to generate permissions that can be used later, can be skipped, doesn't create any resource based on it. | `string` | `"NULL"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for container registry. | `string` | n/a | yes |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | Suffix that is going to be added in the end of CR name. | `string` | `"app"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the container registry |
| <a name="output_name"></a> [name](#output\_name) | Name of the container registry |
| <a name="output_policy"></a> [policy](#output\_policy) | policies that allow push and pull to this container registry by user |
| <a name="output_url"></a> [url](#output\_url) | url to push/pull containers to/from |
