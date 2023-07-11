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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0, < 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0, < 5.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0, < 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_administrators"></a> [administrators](#module\_administrators) | ../aws-eks-iam-role-group | n/a |
| <a name="module_aws_namespace"></a> [aws\_namespace](#module\_aws\_namespace) | ./aws | n/a |
| <a name="module_developers"></a> [developers](#module\_developers) | ../aws-eks-iam-role-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_user.ci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_admin_role_principals"></a> [additional\_admin\_role\_principals](#input\_additional\_admin\_role\_principals) | List of additional role principal ARNs. Principals are able to directly assume admin role. | `list(string)` | `[]` | no |
| <a name="input_additional_developer_role_principals"></a> [additional\_developer\_role\_principals](#input\_additional\_developer\_role\_principals) | List of additional role principal ARNs. Principals are able to directly assume developer role. | `list(string)` | `[]` | no |
| <a name="input_admin_kubernetes_role_rules"></a> [admin\_kubernetes\_role\_rules](#input\_admin\_kubernetes\_role\_rules) | Standard set of Kubernetes role rules to add to admin group. If not changed, it contains safe, namespace-scoped defaults fitting most use case cases. | <pre>list(object({<br>    resources  = list(string)<br>    api_groups = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_admin_kubernetes_role_rules_extra"></a> [admin\_kubernetes\_role\_rules\_extra](#input\_admin\_kubernetes\_role\_rules\_extra) | Additional Kubernetes role rules to add to admin group. | <pre>list(object({<br>    resources  = list(string)<br>    api_groups = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_administrators"></a> [administrators](#input\_administrators) | List of IAM user names that will be added to administrators group. | `list(string)` | `[]` | no |
| <a name="input_administrators_iam_policies"></a> [administrators\_iam\_policies](#input\_administrators\_iam\_policies) | { name: arn } map of policies to attach to administrators group. | `map(string)` | `{}` | no |
| <a name="input_create_ci_iam_user"></a> [create\_ci\_iam\_user](#input\_create\_ci\_iam\_user) | Whether to create a dedicated IAM user for CI | `bool` | `false` | no |
| <a name="input_developer_kubernetes_role_rules"></a> [developer\_kubernetes\_role\_rules](#input\_developer\_kubernetes\_role\_rules) | Standard set of Kubernetes role rules to add to developer group. If not changed, it contains safe defaults fitting most use case cases. | <pre>list(object({<br>    resources  = list(string)<br>    api_groups = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_developer_kubernetes_role_rules_extra"></a> [developer\_kubernetes\_role\_rules\_extra](#input\_developer\_kubernetes\_role\_rules\_extra) | Additional Kubernetes role rules to add to developer group. | <pre>list(object({<br>    resources  = list(string)<br>    api_groups = list(string)<br>    verbs      = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_developers"></a> [developers](#input\_developers) | List of IAM user names that will be added to developers group. | `list(string)` | `[]` | no |
| <a name="input_developers_iam_policies"></a> [developers\_iam\_policies](#input\_developers\_iam\_policies) | { name: arn } map of policies to attach to developers group. | `map(string)` | `{}` | no |
| <a name="input_ecr_arn_list"></a> [ecr\_arn\_list](#input\_ecr\_arn\_list) | ECR repository ARN list. If not provided there will be created ECR repo with the same name as namespace | `list(string)` | `[]` | no |
| <a name="input_iam_path"></a> [iam\_path](#input\_iam\_path) | AWS IAM base path for all resources created for namespace | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels that are going to be attached to namespace | `map(string)` | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The name of namespace to be created on a cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_administrator_role"></a> [administrator\_role](#output\_administrator\_role) | AWS IAM role ID with all necessary permissions for managing Kubernetes, assumable by administrators group. |
| <a name="output_administrators_aws_auth_entry"></a> [administrators\_aws\_auth\_entry](#output\_administrators\_aws\_auth\_entry) | An IAM-Kubernetes binding for administrators group, that has to be put to 'aws-auth' ConfigMap. |
| <a name="output_administrators_group"></a> [administrators\_group](#output\_administrators\_group) | AWS IAM group name for administrators group. |
| <a name="output_administrators_iam_policies"></a> [administrators\_iam\_policies](#output\_administrators\_iam\_policies) | All AWS IAM policies assigned to administrators group. |
| <a name="output_administrators_kubernetes_group"></a> [administrators\_kubernetes\_group](#output\_administrators\_kubernetes\_group) | Kubernetes group for administrators IAM group. Can be used in 'aws-auth' ConfigMap as element of 'groups' entry. |
| <a name="output_administrators_kubernetes_role"></a> [administrators\_kubernetes\_role](#output\_administrators\_kubernetes\_role) | Kubernetes role for administrators IAM group. Can be used in 'aws-auth' ConfigMap as 'username' entry. |
| <a name="output_ci_user"></a> [ci\_user](#output\_ci\_user) | n/a |
| <a name="output_ci_user_arn"></a> [ci\_user\_arn](#output\_ci\_user\_arn) | n/a |
| <a name="output_developer_role"></a> [developer\_role](#output\_developer\_role) | AWS IAM role ID with all necessary permissions for monitoring Kubernetes, assumable by developers group. |
| <a name="output_developers_aws_auth_entry"></a> [developers\_aws\_auth\_entry](#output\_developers\_aws\_auth\_entry) | An IAM-Kubernetes binding for developers group, that has to be put to 'aws-auth' ConfigMap. |
| <a name="output_developers_group"></a> [developers\_group](#output\_developers\_group) | AWS IAM group name for developers group. |
| <a name="output_developers_iam_policies"></a> [developers\_iam\_policies](#output\_developers\_iam\_policies) | All AWS IAM policies assigned to developers group. |
| <a name="output_developers_kubernetes_group"></a> [developers\_kubernetes\_group](#output\_developers\_kubernetes\_group) | Kubernetes group for developers IAM group. Can be used in 'aws-auth' ConfigMap as element of 'groups' entry. |
| <a name="output_developers_kubernetes_role"></a> [developers\_kubernetes\_role](#output\_developers\_kubernetes\_role) | Kubernetes role for developers IAM group. Can be used in 'aws-auth' ConfigMap as 'username' entry. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
