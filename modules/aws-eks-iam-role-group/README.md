# AWS EKS IAM Role Group  
Defines AWS IAM group connected to Kubernetes Role.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| kubernetes | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| iam\_group | AWS IAM group name. Users assigned to group will be able to assume IAM role which is bound to Kubernetes role. | `string` | n/a | yes |
| iam\_group\_policies | AWS IAM group policies to be attached in {name: arn} map format. | `map(string)` | `{}` | no |
| iam\_group\_users | Users to be added to IAM group | `list(string)` | `[]` | no |
| iam\_path | AWS IAM base path for all resources created for namespace | `string` | n/a | yes |
| iam\_role | AWS IAM role name. It is bound to Kubernetes role. | `string` | n/a | yes |
| kubernetes\_namespace | If not specified, a ClusterRole will be created. Otherwise a Role will be scoped to a single Kubernetes Namespace. | `string` | n/a | yes |
| kubernetes\_role | The name of Kubernetes Role to be created | `string` | n/a | yes |
| kubernetes\_role\_rules | RBAC rules for the role | <pre>list(object({<br>    api_groups = list(string)<br>    resources  = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_auth\_entry | An IAM-Kubernetes binding that has to be put to aws-auth ConfigMap. |
| iam\_group | n/a |
| iam\_group\_arn | n/a |
| iam\_role | n/a |
| kubernetes\_namespace | n/a |
| kubernetes\_role | n/a |

