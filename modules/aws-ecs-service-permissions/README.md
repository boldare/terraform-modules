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
| attached\_policies | List of IAM policy ARNs to attach to service | `list(string)` | `[]` | no |
| name | Name of a service. | `string` | n/a | yes |
| secret\_arns | List of AWS Secret Manager secrets. Specify ARNs of secrets that may be accessed by this service. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| execution\_role\_arn | n/a |
| execution\_role\_id | n/a |
| iam\_role\_attacher\_policy\_arn | n/a |
| task\_role\_arn | n/a |
| task\_role\_id | n/a |

