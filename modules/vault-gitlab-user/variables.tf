variable "name" {
  type = string
}

variable "email" {
  type = string
}

variable "gitlab_accessor" {
  type = string
}

variable "existing_user" {
  type = bool
  default = false
}
