## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| kubernetes | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrators | List of IAM user names that will be added to administrators group. | `list(string)` | `[]` | no |
| administrators\_iam\_policies | { name: arn } map of policies to attach to administrators group. | `map(string)` | `{}` | no |
| developers | List of IAM user names that will be added to developers group. | `list(string)` | `[]` | no |
| developers\_iam\_policies | { name: arn } map of policies to attach to developers group. | `map(string)` | `{}` | no |
| external\_arn\_admin\_role | List of external ARNs to get access to admin role | `list(string)` | `[]` | no |
| external\_arn\_developer\_role | List of external ARNs to get access to developer role | `list(string)` | `[]` | no |
| iam\_path | AWS IAM base path for all resources created for namespace | `string` | `null` | no |
| namespace | The name of namespace to be created on a cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| administrator\_role | n/a |
| administrators\_aws\_auth\_entry | n/a |
| administrators\_group | n/a |
| ci\_user | n/a |
| ci\_user\_arn | n/a |
| developer\_role | n/a |
| developers\_aws\_auth\_entry | n/a |
| developers\_group | n/a |
| namespace | n/a |

