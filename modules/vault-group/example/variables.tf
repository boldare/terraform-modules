variable "non_prod_secret_engines" {
  type = object({
    kv       = string
    rabbitmq = string
    mongodb  = string
  })
  description = "Identifiers of Vault secret engines used by our apps."
}

variable "prod_secret_engines" {
  type = object({
    kv       = string
    rabbitmq = string
    mongodb  = string
  })
  description = "Identifiers of Vault secret backends used by our apps."
}

variable "non_prod_access" {
  type        = list(string)
  description = "List of entities (i.e. developers) with full access to non-prod environments"
}

variable "prod_access" {
  type        = list(string)
  description = "List of entities (i.e. developers) with full access to all environments"
}
