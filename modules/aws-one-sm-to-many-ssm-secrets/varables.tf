variable "external_secret_arn" {
  type        = string
  description = "ARN of SecretManager secret entry"
}

variable "name" {
  type        = string
  description = "prefix used in SSM secrets"
}