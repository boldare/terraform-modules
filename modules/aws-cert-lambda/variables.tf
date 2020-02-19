variable "name_prefix" {
  type = string
  description = "Name prefix for all AWS resources that are created with this module."
}

variable "hosted_zone_id" {
  type = string
  description = "Identifier of a Hosted Zone in Route53. Lambda will get permissions to modify entries in this Hosted Zone for certificate validation purpose."
}

variable "owner_email" {
  type = string
  description = "E-mail of the domain owner. Lets Encrypt uses that e-mail address to send reminders regarding domain expiration. Using an alias is recommended, as it let's you avoid having a single person as a manager, i.e. devops-team@domain.org"
}

variable "s3_bucket_name" {
  type = string
  description = "Name of existing S3 bucket which will be used to store TLS certificates obtained from Let's Encrypt."
}

variable "s3_bucket_prefix" {
  type = string
  description = "Path to certificates on exiting S3 bucket"
}

variable "refresh_frequency_cron" {
  type = string
  default = "0 */12 * * ? *"
  description = "CRON expresstion that determines when Vault should restart in order to refresh TLS certificates. Default: Run every 12 hours"
}

variable "domain_names" {
  description = "The domain name to use in the DNS A record for the Vault ELB (e.g. vault.example.com). Make sure that a) this is a domain within the var.hosted_zone_domain_name hosted zone and b) this is the same domain name you used in the TLS certificates for Vault. Only used if var.create_dns_entry is true."
  type        = list(string)
  default     = null
}
