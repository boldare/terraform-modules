variable "vault_domain" {
  type        = string
  description = "Domain for your Vault installation. This is used to redirect you back to Vault from external service after authentication."
}

variable "role_name" {
  type        = string
  description = "Role name for this OIDC Auth"
}

variable "domain" {
  type        = string
  description = "Domain used to authenticate (i.e. gitlab.com)"
}

variable "client_id" {
  type        = string
  description = "OpenID client identifier. It should be generated on target service."
}

variable "client_secret" {
  type        = string
  description = "OpenID client secret. It should be generated on target service."
}

variable "default_token_policies" {
  type        = list(string)
  description = "Default policy for everyone that's authorized using this method. I.e. this policies may allow access to cubbyhole and utilities."
}

variable "ttl" {
  type        = number
  default     = 12 * 60 * 60
  description = "Time-To-Live (in seconds) for Vault tokens genereated by this method. It should be set to a time comfortable for all users, yet still short enough to be safe in case of breach."
}

variable "scopes" {
  type        = list(string)
  default     = ["profile", "email"]
  description = "This is a list of scopes/permissions you will be asked to provide during login via target service."
}

variable "path" {
  type        = string
  default     = "oidc"
  description = "Path to place this auth method. It can be just 'gitlab' for GitLab."
}

variable "description" {
  type        = string
  default     = "OpenID Connect auth method."
  description = "Description of this auth method. You should write something that provides more than just a name here."
}