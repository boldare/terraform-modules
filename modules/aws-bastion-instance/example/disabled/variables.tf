variable "vpc_id" {
  type        = string
  description = "Identifier of VPC where the bastion instance is placed."
}

variable "subnet_id" {
  type        = string
  description = "Identifier of Public Subnet Id where the bastion instance is placed."
}
