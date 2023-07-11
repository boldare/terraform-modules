# Oracle user
Simple module creating user and creating policies.

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
| [oci_identity_api_key.terraform_user_api_keys](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_api_key) | resource |
| [oci_identity_auth_token.terraform_user_auth_token](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_auth_token) | resource |
| [oci_identity_customer_secret_key.terraform_user_secret_keys](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_customer_secret_key) | resource |
| [oci_identity_group.terraform_user_group](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_group) | resource |
| [oci_identity_policy.terraform_policy](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_smtp_credential.terraform_user_smtp_credentials](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_smtp_credential) | resource |
| [oci_identity_user.terraform_user](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_user) | resource |
| [oci_identity_user_capabilities_management.terraform_user](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_user_capabilities_management) | resource |
| [oci_identity_user_group_membership.terraform_user_group_membership](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_user_group_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_api_key"></a> [allow\_api\_key](#input\_allow\_api\_key) | If api key should be allowed to be used in this account | `bool` | `false` | no |
| <a name="input_api_rsa_keys"></a> [api\_rsa\_keys](#input\_api\_rsa\_keys) | RSA public key in PEM format used to create API key. Required if `set_api_key` is true | `string` | `""` | no |
| <a name="input_can_use_console_password"></a> [can\_use\_console\_password](#input\_can\_use\_console\_password) | If user is allowed to create console password (it won't be created by terraform) | `bool` | `false` | no |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | n/a | `string` | n/a | yes |
| <a name="input_create_auth_tokens"></a> [create\_auth\_tokens](#input\_create\_auth\_tokens) | If auth token should be created by terraform | `bool` | `false` | no |
| <a name="input_create_customer_secret_key"></a> [create\_customer\_secret\_key](#input\_create\_customer\_secret\_key) | If customer secret key should be created by terraform | `bool` | `false` | no |
| <a name="input_create_smtp_credentials"></a> [create\_smtp\_credentials](#input\_create\_smtp\_credentials) | If smtp credentials should be created by terraform | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_group_description"></a> [group\_description](#input\_group\_description) | The description you assign to the group during creation. Does not have to be unique, and it's changeable. | `string` | `"Group created by Terraform"` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | The name you assign to the group during creation. The name must be unique across all groups in the tenancy and cannot be changed. | `string` | n/a | yes |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | The description you assign to the policy during creation. Does not have to be unique, and it's changeable. | `string` | `"Group created by Terraform"` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The name you assign to the policy during creation. The name must be unique across all policies in the tenancy and cannot be changed. | `string` | n/a | yes |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | An array of policy statements written in the policy language. | `list(string)` | n/a | yes |
| <a name="input_set_api_key"></a> [set\_api\_key](#input\_set\_api\_key) | If api key should be managed by terraform | `bool` | `false` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | n/a | `string` | n/a | yes |
| <a name="input_tokens_description"></a> [tokens\_description](#input\_tokens\_description) | The description you assign to all access tokens (api/auth/smtp etc.) during creation. Does not have to be unique, and it's changeable. | `string` | `"Terraform Auth Token"` | no |
| <a name="input_user_description"></a> [user\_description](#input\_user\_description) | The description you assign to the user during creation. Does not have to be unique, and it's changeable. | `string` | `"User created by Terraform"` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | The name you assign to the user during creation. This is the user's login for the Console. The name must be unique across all users in the tenancy and cannot be changed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_token"></a> [api\_token](#output\_api\_token) | API token of the user |
| <a name="output_auth_token"></a> [auth\_token](#output\_auth\_token) | Auth token of the user |
| <a name="output_customer_secret_key"></a> [customer\_secret\_key](#output\_customer\_secret\_key) | customer secret keys of the user |
| <a name="output_name"></a> [name](#output\_name) | Name of the user |
| <a name="output_smtp_credential"></a> [smtp\_credential](#output\_smtp\_credential) | SMTP credentials of the user |
