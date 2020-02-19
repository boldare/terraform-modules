variable "name" {
  type        = string
  default     = "Authorization"
  description = "Policy name"
}

variable "authorization_policy_path_prefix" {
  type        = string
  description = "Path that applies to all users in authorization policy. Must end with '/'. It's used to create Resource like 'arn:aws:iam::*:user/authorization_policy_path_prefix/$${aws:username}'."
  default     = ""
}
