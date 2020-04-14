variable "name" {
  type        = string
  description = "Name of the Cognito User Pool and a prefix for it's subresources."
}

variable "tags" {
  type        = map(string)
  description = "AWS resource tags that will be attached to the User Pool."
  default     = {}
}

variable "attributes" {
  type = list(object({
    name = string
    type = string
    # "String" or "Number"
    required                 = bool
    mutable                  = bool
    developer_only_attribute = bool
    constraints              = any
  }))
  default     = []
  description = "Attributes used in Cognito Pool."
}

variable "email_verification_message" {
  type        = string
  default     = "Your verification code is {####}."
  description = "E-mail template containing verification code after registration."
}

variable "email_verification_message_by_link" {
  type        = string
  default     = "Please click the link below to verify your email address. {##Verify Email##}"
  description = "E-mail template containing verification link sent after registration."
}

variable "email_verification_subject_by_link" {
  type        = string
  default     = "Your verification link"
  description = "E-mail subject for e-mail containing verification link sent after registration."
}

variable "email_verification_subject" {
  type        = string
  default     = "Your verification code"
  description = "E-mail subject for e-mail containing verification code sent after registration."
}

variable "sms_authentication_message" {
  type        = string
  default     = "Your authentication code is {####}."
  description = "SMS template containing authentication code. Used for MFA."
}

variable "sms_verification_message" {
  type        = string
  default     = "Your verification code is {####}."
  description = "SMS template containing verification code sent after registration."
}


variable "email_invitation_message" {
  type        = string
  default     = "Your username is {username} and temporary password is {####}."
  description = "E-mail template containing user credentials sent after registration."
}

variable "email_invitation_subject" {
  type        = string
  default     = "Your temporary password"
  description = "E-mail subject for e-mail containing user credentials sent after registration."
}

variable "sms_invitation_message" {
  type        = string
  default     = "Your username is {username} and temporary password is {####}."
  description = "SMS template containing user credentials sent after registration."
}

variable "email_reply" {
  type        = string
  description = "The e-mail address that is shown in Reply To field when user receives an e-mail."
}

variable "email_source_arn" {
  type        = string
  description = "ARN of a verified Amazon SES e-mail address that is shown in From field when user receives an e-mail."
}

variable "mfa_configuration" {
  type        = string
  default     = "OPTIONAL"
  description = "Setting if Multi-Factor Authentication should be turned ON"
}

variable "allow_admin_create_user_only" {
  type        = bool
  default     = "true"
  description = "Settings if only the administrator is allowed to create user profiles"
}

variable "password_policy" {
  type = object({
    minimum_length    = number
    require_lowercase = bool
    require_numbers   = bool
    require_symbols   = bool
    require_uppercase = bool
  })
  default = {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
  description = "Object with information about password policy"
}

variable "default_email_option" {
  type        = string
  default     = "CONFIRM_WITH_CODE"
  description = "Default email verification option"
}

/*
TODO - add a flag
variable "enable_sms" {
  type = bool
  description = "Enable text messages as a second factor for authorization."
}
*/
