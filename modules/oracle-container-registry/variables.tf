variable "compartment_id" {
  description = "Compartment ID in which to create container registry."
  type        = string
}
variable "project_name" {
  description = "The project name."
  type        = string
}
variable "environment" {
  description = "The environment name."
  type        = string
}
variable "region" {
  description = "Region for container registry."
  type        = string
}
variable "suffix" {
  description = "Suffix that is going to be added in the end of CR name."
  type        = string
  default     = "app"
}
variable "group_name_for_permission" {
  type        = string
  default     = "NULL"
  description = "Used only to generate permissions that can be used later, can be skipped, doesn't create any resource based on it."
}
variable "container_repository_is_immutable" {
  description = "Whether the repository is immutable. Images cannot be overwritten in an immutable repository."
  type        = bool
  default     = false
}
variable "container_repository_is_public" {
  description = "Whether the repository is public. A public repository allows unauthenticated access."
  type        = bool
  default     = false
}
