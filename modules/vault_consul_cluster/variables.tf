variable "aws_region" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vault_additional_user_data" {
  type    = string
  default = ""
}

variable "consul_additional_user_data" {
  type    = string
  default = ""
}

variable "s3_backend_admin_arns" {
  type        = list(string)
  description = "Roles or user that should have access to files on Vault's S3 backend"
  default     = []
}

variable "cert_s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket which will be used to store TLS certificates and Vault unseal keys"
}

variable "cert_s3_bucket_tls_cert_file" {
  type        = string
  description = "Path to TLS certificate file"
}

variable "cert_s3_bucket_tls_key_file" {
  type        = string
  description = "Path to TLS key file"
}

variable "cert_refresh_cron" {
  type        = string
  default     = "0 0,12 * * *"
  description = "CRON expresstion that determines when Vault should restart in order to refresh TLS certificates. Defaults to 12 hours"
}

variable "create_dns_entry" {
  description = "If set to true, this module will create a Route 53 DNS A record for the ELB in the var.hosted_zone_id hosted zone with the domain name in var.vault_domain_name."
  type        = bool
  default     = false
}

variable "vault_domain_name" {
  description = "The domain name to use in the DNS A record for the Vault ELB (e.g. vault.example.com). Make sure that a) this is a domain within the var.hosted_zone_domain_name hosted zone and b) this is the same domain name you used in the TLS certificates for Vault. Only used if var.create_dns_entry is true."
  type        = string
  default     = null
}

variable "ami_id" {
  description = "The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under components/vault-ami/vault-consul.json."
  type        = string
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
}

variable "vault_cluster_name" {
  description = "What to name the Vault server cluster and all of its associated resources"
  type        = string
}

variable "consul_cluster_name" {
  description = "What to name the Consul server cluster and all of its associated resources"
  type        = string
}

variable "vault_cluster_size" {
  description = "The number of Vault server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
}

variable "consul_cluster_size" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
}

variable "vault_instance_type" {
  description = "The type of EC2 Instance to run in the Vault ASG"
  type        = string
}

variable "consul_instance_type" {
  description = "The type of EC2 Instance to run in the Consul ASG"
  type        = string
}

variable "consul_cluster_tag_key" {
  description = "The tag the Consul EC2 Instances will look for to automatically discover each other and form a cluster."
  type        = string
}

variable "ssh_security_group_ids" {
  type        = list(string)
  description = "Bastion Host Security Group Ids - to allow SSH access to Vault/Consul machines"
  default     = []
}
