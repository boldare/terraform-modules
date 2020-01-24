variable "bucket_name" {
  type = string
  description = "S3 Bucket Name"
}

variable "bucket_cors" {
  type = list(object({
    allowed_origins = list(string)
    allowed_methods = list(string)
    max_age_seconds = number
    allowed_headers = list(string)
  }))
  default = []
  description = "S3 Bucket CORS"
}

variable "no_public_access" {
  type = bool
  default = false
  description = "Block all public access to bucket"
}
