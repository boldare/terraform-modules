variable "vault_domain" {
  type = string
}

variable "gitlab_domain" {
  type = string
}

variable "gitlab_client_id" {
  type = string
}

variable "gitlab_client_secret" {
  type = string
}

variable "default_token_policies" {
  type = list(string)
}
