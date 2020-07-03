variable "namespace" {
  type        = string
  description = "The name of namespace to be created on a cluster"
}

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

variable "iam_path" {
  type        = string
  default     = null
  description = "AWS IAM base path for all resources created for namespace"
}

variable "external_arn_admin_roles" {
  type        = list(string)
  default     = []
  description = "List of external ARNs to get access to admin role"
}

variable "external_arn_developer_roles" {
  type        = list(string)
  default     = []
  description = "List of external ARNs to get access to developer role"
}
