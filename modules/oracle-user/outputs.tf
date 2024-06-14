output "name" {
  description = "Name of the user"
  value       = oci_identity_user.terraform_user.name
}

output "api_token" {
  description = "API token of the user"
  value       = oci_identity_api_key.terraform_user_api_keys[*]
}

output "auth_token" {
  description = "Auth token of the user"
  value       = oci_identity_auth_token.terraform_user_auth_token[*].token
}

output "customer_secret_key" {
  description = "customer secret keys of the user"
  value = {
    "access-key" = oci_identity_customer_secret_key.terraform_user_secret_keys[*].id
    "secret-key" = oci_identity_customer_secret_key.terraform_user_secret_keys[*].key
  }
}

output "smtp_credential" {
  description = "SMTP credentials of the user"
  value = {
    "username" = oci_identity_smtp_credential.terraform_user_smtp_credentials[*].username
    "password" = oci_identity_smtp_credential.terraform_user_smtp_credentials[*].password
  }
}