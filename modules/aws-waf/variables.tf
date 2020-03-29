variable "name" {
  type = string
}

variable "allowed_cidrs" {
  type        = list(string)
  default     = []
  description = "List of whitelisted CIDR address blocks."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags that will be applied to all underlying resources that support it."
}
