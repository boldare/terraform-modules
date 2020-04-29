variable "name" {
  type        = string
  description = "Name of group will be used to create a group and a corresponding KV stores"
}

variable "managers" {
  type        = list(string)
  default     = []
  description = "List of identities that can CRUD inside all environments"
}

variable "readers" {
  type        = list(string)
  default     = []
  description = "List of identities that can only read inside all environments"
}
variable "environments" {
  type = map(object({
    managers = list(string),
    readers  = list(string),
  }))
  default     = {}
  description = "Map of environments, each with specific identities that can either modify or only read defined values"
}
