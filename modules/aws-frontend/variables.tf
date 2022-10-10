variable "name" {
  type        = string
  description = "Name of S3 bucket to store frontend app in."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false if you don't want to create any resources."
}

variable "create_distribution_dns_records" {
  type        = bool
  default     = true
  description = "Set to false if you don't want to create DNS records for frontend. DNS domain validation will take place regardless of this flag."
}

variable "domain_name" {
  type        = string
  description = "Domain under which frontend app will become available."
}

variable "alternative_domain_names" {
  type        = list(string)
  default     = []
  description = "Alternative domains under which frontend app will become available."
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53 Zone ID to put DNS record for frontend app."
}

variable "comment" {
  type        = string
  default     = "Frontend application environment"
  description = "Comment that will be applied to all underlying resources that support it."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags that will be applied to all underlying resources that support it."
}

variable "cache_disabled_path_patterns" {
  type        = list(string)
  default     = []
  description = "List of path patterns that won't be cached on CloudFront."
}

variable "wait_for_deployment" {
  type        = bool
  default     = false
  description = "If enabled, the resource will wait for the CloudFront distribution status to change from InProgress to Deployed."
}

variable "content_security_policy" {
  type        = map(string)
  description = "Content Security Policy header parameters."
  default = {
    "default-src" = "'self' blob:"
    "font-src"    = "'self'"
    "img-src"     = "'self'"
    "object-src"  = "'none'"
    "script-src"  = "'self' 'unsafe-inline' 'unsafe-eval'"
    "style-src"   = "'self' 'unsafe-inline'"
    "worker-src"  = "blob:"
  }
}

variable "web_acl_id" {
  type        = string
  default     = null
  description = "WebACL ID for enabling whitelist access to CloudFront distribution."
}

variable "custom_headers" {
  type        = map(string)
  default     = {}
  description = "Custom headers that may override headers returned by default."
}

variable "edge_functions" {
  type = map(object({
    event_type     = string
    include_body   = bool
    lambda_code    = string
    lambda_runtime = string
  }))
  default     = {}
  description = "Additional Lambda@Edge functions that tmay be added to CloudFront setup."
}

variable "lambda_log_retention_in_days" {
  type        = number
  default     = 14
  description = "CloudWatch log rentention time for Lambda@Edge functions."
}

variable "scheduled_for_deletion" {
  type        = bool
  default     = false
  description = "Enable this to disconnect Lambda@Edge functions from CloudFront distribution and enables force_Destroy on S3 bucket. It's necessary to proceed with module deletion."
}

variable "default_root_object" {
  type        = string
  description = "The object that you want CloudFront to return when an end user requests the root URL." 
  default     = "index.html"
}

variable "not_found_page_path" {
  type        = string
  description = "Fallback file to return when 404 error is encountered" 
  default     = "/index.html"
}

