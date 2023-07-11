# Oracle Cloud object storage s3 compatible
Module creating object storage bucket with user, groups and all permissions required to use it as drop in replacement for s3.

**WARNING! This module by default allows doing HEAD request, it leads to "leaking" out names of OTHER buckets in compartment!**

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
| [oci_identity_customer_secret_key.bucket_access](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_customer_secret_key) | resource |
| [oci_identity_group.group](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_group) | resource |
| [oci_identity_policy.allow_head](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_policy.allow_read](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_user.bucket](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_user) | resource |
| [oci_identity_user_group_membership.group_member](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_user_group_membership) | resource |
| [oci_objectstorage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/objectstorage_bucket) | resource |
| [oci_objectstorage_namespace.namespace](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/objectstorage_namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_head"></a> [allow\_head](#input\_allow\_head) | READ WARNING!! If bucket user can run HEAD request. Required by PHP to check if bucket exist. | `bool` | `true` | no |
| <a name="input_auto_tiering"></a> [auto\_tiering](#input\_auto\_tiering) | Enabling object storage's auto tiering feature. | `bool` | `false` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | Compartment ID in which to create object storage. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project name. | `string` | n/a | yes |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | Accessibility of bucket, if it should be public or private | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for object storage. | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Tenancy ocid needed to create groups. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of the bucket |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace id of your account |
| <a name="output_s3_access_key"></a> [s3\_access\_key](#output\_s3\_access\_key) | S3 compatible access key for backend |
| <a name="output_s3_access_secret"></a> [s3\_access\_secret](#output\_s3\_access\_secret) | S3 compatible secret key for backend |
| <a name="output_s3_endpoint"></a> [s3\_endpoint](#output\_s3\_endpoint) | Endpoint used for accessing S3 by backend and token authenticated files |
| <a name="output_s3_url"></a> [s3\_url](#output\_s3\_url) | Url used for accessing publicly accessible files |
