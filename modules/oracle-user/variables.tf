variable "user_description" {
  description = "The description you assign to the user during creation. Does not have to be unique, and it's changeable."
  type        = string
  default     = "User created by Terraform"
}
variable "user_name" {
  description = "The name you assign to the user during creation. This is the user's login for the Console. The name must be unique across all users in the tenancy and cannot be changed."
  type        = string
}
variable "group_description" {
  description = "The description you assign to the group during creation. Does not have to be unique, and it's changeable."
  type        = string
  default     = "Group created by Terraform"
}
variable "group_name" {
  description = "The name you assign to the group during creation. The name must be unique across all groups in the tenancy and cannot be changed."
  type        = string
}
variable "policy_description" {
  description = "The description you assign to the policy during creation. Does not have to be unique, and it's changeable."
  type        = string
  default     = "Group created by Terraform"
}
variable "policy_name" {
  description = "The name you assign to the policy during creation. The name must be unique across all policies in the tenancy and cannot be changed."
  type        = string
}
variable "policy_statements" {
  description = "An array of policy statements written in the policy language."
  type        = list(string)
}
variable "tokens_description" {
  description = "The description you assign to all access tokens (api/auth/smtp etc.) during creation. Does not have to be unique, and it's changeable."
  type        = string
  default     = "Terraform Auth Token"
}
variable "allow_api_key" {
  description = "If api key should be allowed to be used in this account"
  type        = bool
  default     = false
}
variable "set_api_key" {
  description = "If api key should be managed by terraform"
  type        = bool
  default     = false
}
variable "api_rsa_keys" {
  type        = string
  description = "RSA public key in PEM format used to create API key. Required if `set_api_key` is true"
  default     = ""
}
variable "create_auth_tokens" {
  description = "If auth token should be created by terraform"
  type        = bool
  default     = false
}
variable "can_use_console_password" {
  description = "If user is allowed to create console password (it won't be created by terraform)"
  type        = bool
  default     = false
}
variable "create_customer_secret_key" {
  description = "If customer secret key should be created by terraform"
  type        = bool
  default     = false
}
variable "create_smtp_credentials" {
  description = "If smtp credentials should be created by terraform"
  type        = bool
  default     = false
}
variable "tenancy_ocid" {
  type = string
}
variable "compartment_id" {
  type = string
}
variable "environment" {
  type = string
}
