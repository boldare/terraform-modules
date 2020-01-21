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
