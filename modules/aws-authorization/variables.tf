variable "max_password_age" {
  type    = number
  default = 180
}

variable "minimum_password_length" {
  type    = number
  default = 20
}

variable "use_various_characters" {
  type        = bool
  description = "Determines if symbols, numbers, uppercase/lowercase characters are required (not needed if passwords are random and long)"
  default     = false
}
