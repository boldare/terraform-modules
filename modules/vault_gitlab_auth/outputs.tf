output "redirect_uris" {
  value = vault_jwt_auth_backend_role.gitlab.allowed_redirect_uris
}

output "accessor" {
  value = vault_jwt_auth_backend.gitlab.accessor
}
