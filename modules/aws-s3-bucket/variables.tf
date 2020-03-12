variable "bucket_name" {
  type        = string
  description = "S3 Bucket Name"
}

variable "acl" {
  type        = string
  default     = null
  description = "Canned ACL for S3 bucket"
}

variable "bucket_policy" {
  type        = string
  default     = null
  description = "S3 Bucket Policy"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Whether to force destroy a bucket in case of removal from Terraform."
}

variable "bucket_cors" {
  type        = list(object({
    allowed_origins = list(string)
    allowed_methods = list(string)
    max_age_seconds = number
    allowed_headers = list(string)
  }))
  default     = []
  description = "S3 Bucket CORS"
}

variable "no_public_access" {
  type        = bool
  default     = false
  description = "Block all public access to bucket"
}
