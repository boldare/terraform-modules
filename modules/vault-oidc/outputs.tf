output "redirect_uris" {
  value = vault_jwt_auth_backend_role.this.allowed_redirect_uris
}

output "accessor" {
  value = vault_jwt_auth_backend.this.accessor
}
