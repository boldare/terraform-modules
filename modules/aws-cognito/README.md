# AWS Cognito
This module provides AWS Cognito User Pool in which SMS & e-mail settings are
configured to opinionated reasonable defaults. One can specify message templates
and attributes that can be included in Cognito database.
An IAM policy for managing pool is provided as an output.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0, < 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_iam_policy.user_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.sms_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.sms_cognito_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [random_uuid.cognito_external_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_iam_policy_document.sms_cognito_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sms_role_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.user_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_admin_create_user_only"></a> [allow\_admin\_create\_user\_only](#input\_allow\_admin\_create\_user\_only) | Settings if only the administrator is allowed to create user profiles | `bool` | `"true"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Attributes used in Cognito Pool. | <pre>list(object({<br>    name = string<br>    type = string<br>    # "String" or "Number"<br>    required                 = bool<br>    mutable                  = bool<br>    developer_only_attribute = bool<br>    constraints              = any<br>  }))</pre> | `[]` | no |
| <a name="input_default_email_option"></a> [default\_email\_option](#input\_default\_email\_option) | Default email verification option | `string` | `"CONFIRM_WITH_CODE"` | no |
| <a name="input_email_invitation_message"></a> [email\_invitation\_message](#input\_email\_invitation\_message) | E-mail template containing user credentials sent after registration. | `string` | `"Your username is {username} and temporary password is {####}."` | no |
| <a name="input_email_invitation_subject"></a> [email\_invitation\_subject](#input\_email\_invitation\_subject) | E-mail subject for e-mail containing user credentials sent after registration. | `string` | `"Your temporary password"` | no |
| <a name="input_email_reply"></a> [email\_reply](#input\_email\_reply) | The e-mail address that is shown in Reply To field when user receives an e-mail. | `string` | n/a | yes |
| <a name="input_email_source_arn"></a> [email\_source\_arn](#input\_email\_source\_arn) | ARN of a verified Amazon SES e-mail address that is shown in From field when user receives an e-mail. | `string` | n/a | yes |
| <a name="input_email_verification_message"></a> [email\_verification\_message](#input\_email\_verification\_message) | E-mail template containing verification code after registration. | `string` | `"Your verification code is {####}."` | no |
| <a name="input_email_verification_message_by_link"></a> [email\_verification\_message\_by\_link](#input\_email\_verification\_message\_by\_link) | E-mail template containing verification link sent after registration. | `string` | `"Please click the link below to verify your email address. {##Verify Email##}"` | no |
| <a name="input_email_verification_subject"></a> [email\_verification\_subject](#input\_email\_verification\_subject) | E-mail subject for e-mail containing verification code sent after registration. | `string` | `"Your verification code"` | no |
| <a name="input_email_verification_subject_by_link"></a> [email\_verification\_subject\_by\_link](#input\_email\_verification\_subject\_by\_link) | E-mail subject for e-mail containing verification link sent after registration. | `string` | `"Your verification link"` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | Setting if Multi-Factor Authentication should be turned ON | `string` | `"OPTIONAL"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Cognito User Pool and a prefix for it's subresources. | `string` | n/a | yes |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | Object with information about password policy | <pre>object({<br>    minimum_length    = number<br>    require_lowercase = bool<br>    require_numbers   = bool<br>    require_symbols   = bool<br>    require_uppercase = bool<br>  })</pre> | <pre>{<br>  "minimum_length": 12,<br>  "require_lowercase": true,<br>  "require_numbers": true,<br>  "require_symbols": true,<br>  "require_uppercase": true<br>}</pre> | no |
| <a name="input_sms_authentication_message"></a> [sms\_authentication\_message](#input\_sms\_authentication\_message) | SMS template containing authentication code. Used for MFA. | `string` | `"Your authentication code is {####}."` | no |
| <a name="input_sms_invitation_message"></a> [sms\_invitation\_message](#input\_sms\_invitation\_message) | SMS template containing user credentials sent after registration. | `string` | `"Your username is {username} and temporary password is {####}."` | no |
| <a name="input_sms_verification_message"></a> [sms\_verification\_message](#input\_sms\_verification\_message) | SMS template containing verification code sent after registration. | `string` | `"Your verification code is {####}."` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS resource tags that will be attached to the User Pool. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_user_pool_arn"></a> [user\_pool\_arn](#output\_user\_pool\_arn) | ARN of created Cognito User Pool. |
| <a name="output_user_pool_id"></a> [user\_pool\_id](#output\_user\_pool\_id) | Identifier of created Cognito User Pool. |
| <a name="output_user_pool_policy_arn"></a> [user\_pool\_policy\_arn](#output\_user\_pool\_policy\_arn) | IAM policy that can be applied to roles and users which will manage this User Pool. |
