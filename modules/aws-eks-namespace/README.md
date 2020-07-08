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
| additional\_admin\_role\_principals | List of additional role principal ARNs. Principals are able to directly assume admin role | `list(string)` | `[]` | no |
| additional\_developer\_role\_principals | List of additional role principal ARNs. Principals are able to directly assume developer role | `list(string)` | `[]` | no |
| administrators | List of IAM user names that will be added to administrators group. | `list(string)` | `[]` | no |
| administrators\_iam\_policies | { name: arn } map of policies to attach to administrators group. | `map(string)` | `{}` | no |
| create\_ci\_iam\_user | Whether to create a dedicated IAM user for CI | `bool` | `false` | no |
| developers | List of IAM user names that will be added to developers group. | `list(string)` | `[]` | no |
| developers\_iam\_policies | { name: arn } map of policies to attach to developers group. | `map(string)` | `{}` | no |
| iam\_path | AWS IAM base path for all resources created for namespace | `string` | `null` | no |
| namespace | The name of namespace to be created on a cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| administrator\_role | n/a |
| administrators\_aws\_auth\_entry | n/a |
| administrators\_group | n/a |
| administrators\_iam\_policies | n/a |
| ci\_user | n/a |
| ci\_user\_arn | n/a |
| developer\_role | n/a |
| developers\_aws\_auth\_entry | n/a |
| developers\_group | n/a |
| developers\_iam\_policies | n/a |
| namespace | n/a |

