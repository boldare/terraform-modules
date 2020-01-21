variable "name" {
  type = string
}

variable "users" {
  type = list(string)
}

variable "attached_policy_arns" {
  type = map(string)
}
