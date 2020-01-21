variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_public_subnet_tags" {
  type    = map(string)
  default = {
    Subnet = "public"
  }
}

variable "egress_security_groups" {
  type    = list(string)
  default = []
}

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "ami_id" {
  type = string
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "Determines who can connect to the bastion instance"
}

variable "volume_size" {
  type        = number
  description = "Root volume size in GB"
  default     = 8
}

variable "ssh_key_name" {
  type    = string
  default = null
}

variable "extra_tags" {
  type    = list(object({
    key                 = string
    value               = string
    propagate_at_launch = bool
  }))
  default = []
}

variable "enable_monitoring" {
  type    = bool
  default = false
}

variable "additional_user_data" {
  type    = string
  default = ""
}
