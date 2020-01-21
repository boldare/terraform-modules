variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "map_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
variable "region" {
  type = string
}

variable "worker_groups" {
  type    = any
  default = []
}

variable "worker_groups_launch_template" {
  type    = any
  default = []
}

variable "admin_iam_roles" {
  type        = list(string)
  description = "ARN Users that have admin access to the cluster"
  default     = []
}

variable "admin_iam_users" {
  type        = list(string)
  description = "ARN Users that have admin access to the cluster"
  default     = []
}
