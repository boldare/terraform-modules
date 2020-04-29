variable "bucket_name" {
  type        = string
  description = "Name of bucket to store SSH keys"
}

variable "ssh_user" {
  type        = string
  description = "User to use to login to instance"
}

variable "keys_update_frequency" {
  type        = string
  default     = "0 * * * *"
  description = "How often keys should be fetched from S3 bucket"
}

variable "ssh_keys" {
  type = list(object({
    name       = string,
    public_key = string
  }))
}
