variable "namespace" {
  type        = string
  description = "The name of namespace to be created on a cluster"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels that are going to be attached to namespace"
}

variable "iam_path" {
  type        = string
  default     = null
  description = "AWS IAM base path for all resources created for namespace"
}

variable "create_ci_iam_user" {
  type        = bool
  default     = false
  description = "Whether to create a dedicated IAM user for CI"
}

variable "ecr_arn_list" {
  description = "ECR repository ARN list. If not provided there will be created ECR repo with the same name as namespace"
  type        = list(string)
  default     = []
}

# ------------------
# ADMIN GROUP
# ------------------

variable "administrators" {
  type        = list(string)
  default     = []
  description = "List of IAM user names that will be added to administrators group."
}

variable "administrators_iam_policies" {
  type        = map(string)
  default     = {}
  description = "{ name: arn } map of policies to attach to administrators group."
}

variable "additional_admin_role_principals" {
  type        = list(string)
  default     = []
  description = "List of additional role principal ARNs. Principals are able to directly assume admin role."
}

variable "admin_kubernetes_role_rules" {
  type = list(object({
    resources  = list(string)
    api_groups = list(string)
    verbs      = list(string)
  }))
  default     = null
  description = "Standard set of Kubernetes role rules to add to admin group. If not changed, it contains safe, namespace-scoped defaults fitting most use case cases."
}

variable "admin_kubernetes_role_rules_extra" {
  type = list(object({
    resources  = list(string)
    api_groups = list(string)
    verbs      = list(string)
  }))
  default     = []
  description = "Additional Kubernetes role rules to add to admin group."
}

# ------------------
# DEVELOPERS GROUP
# ------------------

variable "developers" {
  type        = list(string)
  default     = []
  description = "List of IAM user names that will be added to developers group."
}

variable "developers_iam_policies" {
  type        = map(string)
  default     = {}
  description = "{ name: arn } map of policies to attach to developers group."
}

variable "additional_developer_role_principals" {
  type        = list(string)
  default     = []
  description = "List of additional role principal ARNs. Principals are able to directly assume developer role."
}

variable "developer_kubernetes_role_rules" {
  type = list(object({
    resources  = list(string)
    api_groups = list(string)
    verbs      = list(string)
  }))
  default     = null
  description = "Standard set of Kubernetes role rules to add to developer group. If not changed, it contains safe defaults fitting most use case cases."
}

variable "developer_kubernetes_role_rules_extra" {
  type = list(object({
    resources  = list(string)
    api_groups = list(string)
    verbs      = list(string)
  }))
  default     = []
  description = "Additional Kubernetes role rules to add to developer group."
}
