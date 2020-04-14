variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "app_task_role_arn" {
  type = string
}

variable "app_execution_role_arn" {
  type = string
}

variable "network_workloads_sg_id" {
  type = string
}

variable "network_private_subnets" {
  type = string
}

variable "network_vpc_id" {
  type = string
}

variable "network_lb_arn" {
  type = string
}

variable "api_certificate_arn" {
  type = string
}

variable "secret_arn" {
  type = string
}

