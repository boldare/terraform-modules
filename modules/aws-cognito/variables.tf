variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "attributes" {
  type        = list(object({
    name                     = string
    type                     = string # "String" or "Number"
    required                 = bool
    mutable                  = bool
    developer_only_attribute = bool
    constraints = any
  }))
  default     = []
  description = "Attributes used in Cognito Pool"
}

variable "email_verification_message" {
  type    = string
  default = "Your verification code is {####}."
}

variable "email_verification_message_by_link" {
  type    = string
  default = "Please click the link below to verify your email address. {##Verify Email##}"
}

variable "email_verification_subject_by_link" {
  type    = string
  default = "Your verification link"
}

variable "email_verification_subject" {
  type    = string
  default = "Your verification code"
}

variable "sms_authentication_message" {
  type    = string
  default = "Your authentication code is {####}."
}

variable "sms_verification_message" {
  type    = string
  default = "Your verification code is {####}."
}


variable "email_invitation_message" {
  type    = string
  default = "Your username is {username} and temporary password is {####}."
}

variable "email_invitation_subject" {
  type    = string
  default = "Your temporary password"
}

variable "sms_invitation_message" {
  type    = string
  default = "Your username is {username} and temporary password is {####}."
}

variable "email_reply" {
  type = string
}

variable "email_source_arn" {
  type = string
}

variable "domains" {
  type    = map(object({
    domain          = string
    certificate_arn = string
  }))
  default = {}
}

/*
TODO - add a flag
variable "enable_sms" {
  type = bool
  description = "Enable text messages as a second factor for authorization."
}
*/
