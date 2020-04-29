variable "auth_backend_accessor" {
  type        = string
  description = "Auth backend accessor used for authentication. For example, Google OIDC aliases are created."
}

variable "users" {
  type        = map(string)
  default     = {}
  description = "Map of users to create or include in Vault. Map user name to email."
}
