variable "users" {
  type = map(object({
    email = string
  }))
}

