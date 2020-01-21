variable "is_enabled" {
  type    = bool
  default = true
}

variable "alias_name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "key_admin_arns" {
  type    = list(string)
  default = []
}

variable "key_user_arns" {
  type    = list(string)
  default = []
}
