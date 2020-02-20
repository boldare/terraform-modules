# AWS KMS Key  
This module creates KMS key, adds an alias and creates Key and IAM policies

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| alias\_name | n/a | `string` | n/a | yes |
| description | n/a | `string` | `""` | no |
| is\_enabled | n/a | `bool` | `true` | no |
| key\_admin\_arns | n/a | `list(string)` | `[]` | no |
| key\_user\_arns | n/a | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_admin\_policy\_arn | n/a |
| iam\_user\_policy\_arn | n/a |
| kms\_key\_arn | n/a |
| kms\_key\_id | n/a |

