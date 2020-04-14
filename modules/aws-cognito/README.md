# AWS Cognito  
This module provides AWS Cognito User Pool in which SMS & e-mail settings are  
configured to opinionated reasonable defaults. One can specify message templates  
and attributes that can be included in Cognito database.  
An IAM policy for managing pool is provided as an output.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_admin\_create\_user\_only | Settings if only the administrator is allowed to create user profiles | `string` | `"true"` | no |
| attributes | Attributes used in Cognito Pool. | <pre>list(object({<br>    name = string<br>    type = string<br>    # "String" or "Number"<br>    required                 = bool<br>    mutable                  = bool<br>    developer_only_attribute = bool<br>    constraints              = any<br>  }))</pre> | `[]` | no |
| default\_email\_option | Default email verification option | `string` | `"CONFIRM_WITH_CODE"` | no |
| email\_invitation\_message | E-mail template containing user credentials sent after registration. | `string` | `"Your username is {username} and temporary password is {####}."` | no |
| email\_invitation\_subject | E-mail subject for e-mail containing user credentials sent after registration. | `string` | `"Your temporary password"` | no |
| email\_reply | The e-mail address that is shown in Reply To field when user receives an e-mail. | `string` | n/a | yes |
| email\_source\_arn | ARN of a verified Amazon SES e-mail address that is shown in From field when user receives an e-mail. | `string` | n/a | yes |
| email\_verification\_message | E-mail template containing verification code after registration. | `string` | `"Your verification code is {####}."` | no |
| email\_verification\_message\_by\_link | E-mail template containing verification link sent after registration. | `string` | `"Please click the link below to verify your email address. {##Verify Email##}"` | no |
| email\_verification\_subject | E-mail subject for e-mail containing verification code sent after registration. | `string` | `"Your verification code"` | no |
| email\_verification\_subject\_by\_link | E-mail subject for e-mail containing verification link sent after registration. | `string` | `"Your verification link"` | no |
| mfa\_configuration | Setting if Multi-Factor Authentication should be turned ON | `string` | `"OPTIONAL"` | no |
| name | Name of the Cognito User Pool and a prefix for it's subresources. | `string` | n/a | yes |
| password\_policy | Object with information about password policy | <pre>object({<br>    minimum_length    = number<br>    require_lowercase = bool<br>    require_numbers   = bool<br>    require_symbols   = bool<br>    require_uppercase = bool<br>  })</pre> | <pre>{<br>  "minimum_length": 12,<br>  "require_lowercase": true,<br>  "require_numbers": true,<br>  "require_symbols": true,<br>  "require_uppercase": true<br>}</pre> | no |
| sms\_authentication\_message | SMS template containing authentication code. Used for MFA. | `string` | `"Your authentication code is {####}."` | no |
| sms\_invitation\_message | SMS template containing user credentials sent after registration. | `string` | `"Your username is {username} and temporary password is {####}."` | no |
| sms\_verification\_message | SMS template containing verification code sent after registration. | `string` | `"Your verification code is {####}."` | no |
| tags | AWS resource tags that will be attached to the User Pool. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| user\_pool\_arn | ARN of created Cognito User Pool. |
| user\_pool\_id | Identifier of created Cognito User Pool. |
| user\_pool\_policy\_arn | IAM policy that can be applied to roles and users which will manage this User Pool. |

