variable "name" {
  type        = string
  description = "Name of group will be used to create a group and a corresponding KV stores"
}

variable "groups" {
  type = map(object({
    entities     = list(string)
    policies     = list(string)
    environments = list(string)
  }))
  default     = {}
  description = "Groups map entity ids (users/apps) to permissions. Policies can contain \"read\" and/or \"write\"."
}

variable "environments" {
  type        = map(map(list(string)))
  default     = {}
  description = "This maps environment names to objects containing definitions of secret engines used by those environments. For example, your `dev` environment may use `{ rabbitmq = [\"rabbitmq\", \"/rabbitmq/non-prod\"] }` and your `prod` can equal to `{ rabbitmq = [\"rabbitmq\", \"/rabbitmq/prod\"] }`."
}

variable "separator" {
  type        = string
  default     = "-"
  description = "Separator used in places, where regular path nesting is not possible. While in KV you can do `/kv/group/env/key`, in RabbitMQ it has to be non-slash character: `/rabbitmq/group-env-key`."
}
