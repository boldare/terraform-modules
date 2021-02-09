# AWS EKS Namespace  
Use this module to quickly bootstrap an environment for project running on EKS cluster.

This module creates:
- a Kubernetes namespace
- IAM user groups (for administrators and developers)
- optional CI role
- bindings between IAM roles and Kubernetes RBAC roles
- set of ECR, S3 and EKS permissions for IAM roles
- set of RBAC permissions for RBAC roles

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
| additional\_admin\_role\_principals | List of additional role principal ARNs. Principals are able to directly assume admin role. | `list(string)` | `[]` | no |
| additional\_developer\_role\_principals | List of additional role principal ARNs. Principals are able to directly assume developer role. | `list(string)` | `[]` | no |
| admin\_kubernetes\_role\_rules | Standard set of Kubernetes role rules to add to admin group. If not changed, it contains safe, namespace-scoped defaults fitting most use case cases. | <pre>list(object({<br>    resources  = list(string)<br>    api_groups = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `null` | no |
| admin\_kubernetes\_role\_rules\_extra | Additional Kubernetes role rules to add to admin group. | <pre>list(object({<br>    resources  = list(string)<br>    api_groups = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `[]` | no |
| administrators | List of IAM user names that will be added to administrators group. | `list(string)` | `[]` | no |
| administrators\_iam\_policies | { name: arn } map of policies to attach to administrators group. | `map(string)` | `{}` | no |
| create\_ci\_iam\_user | Whether to create a dedicated IAM user for CI | `bool` | `false` | no |
| developer\_kubernetes\_role\_rules | Standard set of Kubernetes role rules to add to developer group. If not changed, it contains safe defaults fitting most use case cases. | <pre>list(object({<br>    resources  = list(string)<br>    api_groups = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `null` | no |
| developer\_kubernetes\_role\_rules\_extra | Additional Kubernetes role rules to add to developer group. | <pre>list(object({<br>    resources  = list(string)<br>    api_groups = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `[]` | no |
| developers | List of IAM user names that will be added to developers group. | `list(string)` | `[]` | no |
| developers\_iam\_policies | { name: arn } map of policies to attach to developers group. | `map(string)` | `{}` | no |
| iam\_path | AWS IAM base path for all resources created for namespace | `string` | `null` | no |
| labels | Labels that are going to be attached to namespace | `map(string)` | `{}` | no |
| namespace | The name of namespace to be created on a cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| administrator\_role | AWS IAM role ID with all necessary permissions for managing Kubernetes, assumable by administrators group. |
| administrators\_aws\_auth\_entry | An IAM-Kubernetes binding for administrators group, that has to be put to 'aws-auth' ConfigMap. |
| administrators\_group | AWS IAM group name for administrators group. |
| administrators\_iam\_policies | All AWS IAM policies assigned to administrators group. |
| administrators\_kubernetes\_group | Kubernetes group for administrators IAM group. Can be used in 'aws-auth' ConfigMap as element of 'groups' entry. |
| administrators\_kubernetes\_role | Kubernetes role for administrators IAM group. Can be used in 'aws-auth' ConfigMap as 'username' entry. |
| ci\_user | n/a |
| ci\_user\_arn | n/a |
| developer\_role | AWS IAM role ID with all necessary permissions for monitoring Kubernetes, assumable by developers group. |
| developers\_aws\_auth\_entry | An IAM-Kubernetes binding for developers group, that has to be put to 'aws-auth' ConfigMap. |
| developers\_group | AWS IAM group name for developers group. |
| developers\_iam\_policies | All AWS IAM policies assigned to developers group. |
| developers\_kubernetes\_group | Kubernetes group for developers IAM group. Can be used in 'aws-auth' ConfigMap as element of 'groups' entry. |
| developers\_kubernetes\_role | Kubernetes role for developers IAM group. Can be used in 'aws-auth' ConfigMap as 'username' entry. |
| namespace | n/a |

