AWS IAM User Group  
This module creates IAM user group, attaches users and policies to it.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| attached\_policy\_arns | n/a | `map(string)` | n/a | yes |
| name | n/a | `string` | n/a | yes |
| path | You can optionally give an optional path to the group. You can use a single path, or nest multiple paths as if they were a folder structure. For example, you could use the nested path /division\_abc/subdivision\_xyz/product\_1234/engineering/ to match your company's organizational structure. | `string` | `"/"` | no |
| users | Map of users with their respective internal keys. Can be { userid = "userid" } | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam\_group | n/a |
| iam\_group\_arn | n/a |

