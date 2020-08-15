# AWS KMS Key  
This module creates KMS key, adds an alias and creates Key and IAM policies

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.49, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.49, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
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

