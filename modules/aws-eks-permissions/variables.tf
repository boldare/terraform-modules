variable "name_prefix" {
  type        = string
  default     = ""
  description = "Name prefix for created policies. No prefix is added by default."
}

variable "dns_create" {
  type        = bool
  default     = false
  description = "Whether to create DNS policy."
}

variable "autoscaling_create" {
  type        = bool
  default     = false
  description = "Whether to create Autoscaling policy."
}

variable "load_balancing_create" {
  type        = bool
  default     = false
  description = "Whether to create Load Balancing policy."
}
