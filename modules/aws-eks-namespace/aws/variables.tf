variable "namespace_name" {
  type = string
}

variable "ecr_arn_list" {
  description = "ECR repository ARN list"
  type        = list(string)
  default     = []
}
