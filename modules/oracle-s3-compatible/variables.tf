variable "compartment_id" {
  description = "Compartment ID in which to create object storage."
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
  description = "Region for object storage."
  type        = string
}

variable "public_access" {
  description = "Accessibility of bucket, if it should be public or private"
  type        = bool
  default     = false
}

variable "auto_tiering" {
  description = "Enabling object storage's auto tiering feature."
  type        = bool
  default     = false
}

variable "allow_head" {
  description = "READ WARNING!! If bucket user can run HEAD request. Required by PHP to check if bucket exist. "
  type        = bool
  default     = true
}

variable "tenancy_ocid" {
  description = "Tenancy ocid needed to create groups."
  type        = string
}
