# AWS EKS IAM Role Group  
Defines AWS IAM group connected to Kubernetes Role.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.49, < 4.0 |
| kubernetes | >= 1.0, < 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.49, < 4.0 |
| kubernetes | >= 1.0, < 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_role\_principals | List of additional role principal ARNs. Principals are able to directly assume role created by this module | `list(string)` | `[]` | no |
| iam\_group | AWS IAM group name. Users assigned to group will be able to assume IAM role which is bound to Kubernetes role. | `string` | n/a | yes |
| iam\_group\_users | Users to be added to IAM group in { [internal id]: "iam id" } format | `map(string)` | `{}` | no |
| iam\_path | AWS IAM base path for all resources created for namespace | `string` | `null` | no |
| iam\_policies | AWS IAM policies to be attached to group and role in {name: arn} map format. | `map(string)` | `{}` | no |
| iam\_role | AWS IAM role name. It is bound to Kubernetes role. | `string` | n/a | yes |
| kubernetes\_namespace | If not specified, a ClusterRole will be created. Otherwise a Role will be scoped to a single Kubernetes Namespace. | `string` | `null` | no |
| kubernetes\_role | The name of Kubernetes Role to be created | `string` | n/a | yes |
| kubernetes\_role\_rules | RBAC rules for the role | <pre>list(object({<br>    api_groups = list(string)<br>    resources  = list(string)<br>    verbs      = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_auth\_entry | An IAM-Kubernetes binding that has to be put to aws-auth ConfigMap. |
| iam\_group | AWS IAM group name for this group. |
| iam\_group\_arn | AWS IAM group ARN for this group. |
| iam\_role | AWS IAM role ID with all necessary permissions for managing Kubernetes, assumable by this group. |
| kubernetes\_group | Kubernetes group for this IAM group. Can be used in 'aws-auth' ConfigMap as element of 'groups' entry. |
| kubernetes\_namespace | Kubernetes namespace to which this IAM group has access to. |
| kubernetes\_role | Kubernetes role for this IAM group. Can be used in 'aws-auth' ConfigMap as 'username' entry. |

