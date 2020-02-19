# AWS EKS IAM Role Group

Defines AWS IAM group connected to Kubernetes Role.

| Variable | Default | Description |
| --- | --- | --- |
|`iam_group`| - | AWS IAM group name. Users assigned to group will be able to assume IAM role which is bound to Kubernetes role |
|`iam_role`| - | AWS IAM role name. It is bound to Kubernetes role. |
| `kubernetes_namespace` | `null` | If not specified, a ClusterRole will be created. Otherwise a Role will be scoped to a single Kubernetes Namespace. |
| `kubernetes_role` | - | The name of Kubernetes Role to be created. |
| `kubernetes_role_rules` | `[]` | RBAC rules for the role. |

| Output | Description |
| --- | --- |
| | |
