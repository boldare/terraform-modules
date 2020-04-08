variable "name" {
  type = string
  description = "Name of bastion instance and a prefix for it's dependencies"
}

variable "vpc_id" {
  type = string
  description = "Identifier of VPC where the bastion instance is placed."
}

variable "public_subnet_id" {
  type    = map(string)
  description = "Identifier of Public Subnet Id where the bastion instance is placed."
}

variable "egress_security_groups" {
  type    = list(string)
  description = "Egress"
  default = []
}

variable "instance_type" {
  type    = string
  description = "Type of EC2 instance."
  default = "t3.nano"
}

variable "ami_id" {
  type = string
  description = "Amazon Machine Image identifier. You can use data.aws_ami to find the right image."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "Determines what CIDRs (i.e. 18.202.145.21/32) can connect to the bastion instance."
}

variable "volume_size" {
  type        = number
  description = "Root volume size in GB."
  default     = 8
}

variable "ssh_key_name" {
  type        = string
  description = "Name of SSH key present in AWS EC2 keys list."
  default     = null
}

variable "extra_tags" {
  type        = list(object({
    key                 = string
    value               = string
    propagate_at_launch = bool
  }))
  description = "AWS Tags that will be added to running bastion instance."
  default     = []
}

variable "enable_monitoring" {
  type        = bool
  description = "Whether to enable EC2 instance monitoring."
  default     = false
}

variable "disable_api_termination" {
  type = bool
  description = "Whether to enable EC2 Instance Termination Protection"
  default = false
}

variable "additional_user_data" {
  type    = string
  description = "Scripts to be ran when instance boots up."
  default = ""
}

variable "eip_id" {
  type = string
  description = "Elastic IP"
  default = null
}