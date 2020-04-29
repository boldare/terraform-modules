variable "users" {
  type = map(object({
    email = string
  }))
  description = "Map of users to be added to AWS IAM"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags attached to all users"
}

variable "path" {
  type        = string
  default     = null
  description = "You can optionally give an optional path to all users. You can use a single path, or nest multiple paths as if they were a folder structure. For example, you could use the nested path /division_abc/subdivision_xyz/product_1234/engineering/ to match your company's organizational structure."
}
