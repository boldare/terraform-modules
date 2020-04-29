variable "aws_account_external_id" {
  type        = string
  description = "AWS External Account ID sets a limit on who can access monitoring on your account. It's generated during AWS Datadog integration setup."
}

variable "aws_region" {
  type        = string
  description = "AWS region to place lambda in. Can be obtained from data.aws_region."
}

variable "api_key" {
  type        = string
  description = "The Datadog API key associated with your Datadog Account."
}

variable "site" {
  type        = string
  description = "Set it to datadoghq.eu for Datadog EU site."
  default     = "datadoghq.com"
}
