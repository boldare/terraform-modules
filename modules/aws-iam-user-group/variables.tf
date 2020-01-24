variable "name" {
  type = string
}

variable "users" {
  type = list(string)
}

variable "attached_policy_arns" {
  type = map(string)
}

variable "path" {
  type        = string
  default     = "/"
  description = "You can optionally give an optional path to the group. You can use a single path, or nest multiple paths as if they were a folder structure. For example, you could use the nested path /division_abc/subdivision_xyz/product_1234/engineering/ to match your company's organizational structure."
}
