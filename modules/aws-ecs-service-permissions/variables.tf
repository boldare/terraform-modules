variable "name" {
  type        = string
  description = "Name of a service."
}

variable "attached_policies" {
  type        = list(string)
  description = "List of IAM policy ARNs to attach to service"
  default     = []
}

variable "secret_arns" {
  type        = list(string)
  description = "List of AWS Secret Manager secrets. Specify ARNs of secrets that may be accessed by this service."
  default     = []
}
