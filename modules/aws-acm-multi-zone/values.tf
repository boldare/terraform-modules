variable "certificates" {
  type        = map(list(string))
  description = "A mapping of hosted zone name to domains."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be added to ACM."
}
