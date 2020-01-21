variable "iam_group" {
  type        = string
  description = "AWS IAM group name. Users assigned to group will be able to assume IAM role which is bound to Kubernetes role."
}

variable "iam_group_policies" {
  type        = map(string)
  default     = {}
  description = "AWS IAM group policies to be attached in {name: arn} map format."
}

variable "iam_group_users" {
  type        = list(string)
  default     = []
  description = "Users to be added to IAM group"
}

variable "iam_role" {
  type        = string
  description = "AWS IAM role name. It is bound to Kubernetes role."
}

variable "kubernetes_namespace" {
  type        = string
  default     = null
  description = "If not specified, a ClusterRole will be created. Otherwise a Role will be scoped to a single Kubernetes Namespace."
}

variable "kubernetes_role" {
  type        = string
  description = "The name of Kubernetes Role to be created"
}

variable "kubernetes_role_rules" {
  type        = list(object({
    api_groups = list(string)
    resources  = list(string)
    verbs      = list(string)
  }))
  default     = []
  description = "RBAC rules for the role"
}
