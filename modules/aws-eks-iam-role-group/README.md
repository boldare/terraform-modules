# AWS EKS IAM Role Group
Defines AWS IAM group connected to Kubernetes Role.

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
| <a name="module_group"></a> [group](#module\_group) | ../aws-iam-user-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_group_policy.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_role.iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.role_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_cluster_role.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_role.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_role_principals"></a> [additional\_role\_principals](#input\_additional\_role\_principals) | List of additional role principal ARNs. Principals are able to directly assume role created by this module | `list(string)` | `[]` | no |
| <a name="input_iam_group"></a> [iam\_group](#input\_iam\_group) | AWS IAM group name. Users assigned to group will be able to assume IAM role which is bound to Kubernetes role. | `string` | n/a | yes |
| <a name="input_iam_group_users"></a> [iam\_group\_users](#input\_iam\_group\_users) | Users to be added to IAM group in { [internal id]: "iam id" } format | `map(string)` | `{}` | no |
| <a name="input_iam_path"></a> [iam\_path](#input\_iam\_path) | AWS IAM base path for all resources created for namespace | `string` | `null` | no |
| <a name="input_iam_policies"></a> [iam\_policies](#input\_iam\_policies) | AWS IAM policies to be attached to group and role in {name: arn} map format. | `map(string)` | `{}` | no |
| <a name="input_iam_role"></a> [iam\_role](#input\_iam\_role) | AWS IAM role name. It is bound to Kubernetes role. | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | If not specified, a ClusterRole will be created. Otherwise a Role will be scoped to a single Kubernetes Namespace. | `string` | `null` | no |
| <a name="input_kubernetes_role"></a> [kubernetes\_role](#input\_kubernetes\_role) | The name of Kubernetes Role to be created | `string` | n/a | yes |
| <a name="input_kubernetes_role_rules"></a> [kubernetes\_role\_rules](#input\_kubernetes\_role\_rules) | RBAC rules for the role | <pre>list(object({<br>    api_groups = list(string)<br>    resources  = list(string)<br>    verbs      = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_auth_entry"></a> [aws\_auth\_entry](#output\_aws\_auth\_entry) | An IAM-Kubernetes binding that has to be put to aws-auth ConfigMap. |
| <a name="output_iam_group"></a> [iam\_group](#output\_iam\_group) | AWS IAM group name for this group. |
| <a name="output_iam_group_arn"></a> [iam\_group\_arn](#output\_iam\_group\_arn) | AWS IAM group ARN for this group. |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | AWS IAM role ID with all necessary permissions for managing Kubernetes, assumable by this group. |
| <a name="output_kubernetes_group"></a> [kubernetes\_group](#output\_kubernetes\_group) | Kubernetes group for this IAM group. Can be used in 'aws-auth' ConfigMap as element of 'groups' entry. |
| <a name="output_kubernetes_namespace"></a> [kubernetes\_namespace](#output\_kubernetes\_namespace) | Kubernetes namespace to which this IAM group has access to. |
| <a name="output_kubernetes_role"></a> [kubernetes\_role](#output\_kubernetes\_role) | Kubernetes role for this IAM group. Can be used in 'aws-auth' ConfigMap as 'username' entry. |
