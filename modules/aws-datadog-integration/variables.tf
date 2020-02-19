variable "aws_account_external_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "api_key" {
  type = string
  description = "The Datadog API key associated with your Datadog Account"
}

variable "site" {
  type = string
  description = "Set it to datadoghq.eu for Datadog EU site"
  default = "datadoghq.com"
}
