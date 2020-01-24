locals {
  gitlab_default_role_name = "gitlab"
}

resource "vault_jwt_auth_backend" "gitlab" {
  description        = "Gitlab"
  path               = "gitlab"
  type               = "oidc"
  oidc_discovery_url = "https://${var.gitlab_domain}"
  oidc_client_id     = var.gitlab_client_id
  oidc_client_secret = var.gitlab_client_secret
  bound_issuer       = var.gitlab_domain
  default_role       = local.gitlab_default_role_name

  tune {
    listing_visibility = "unauth"
  }
}

resource "vault_jwt_auth_backend_role" "gitlab" {
  role_type      = "oidc"
  backend        = vault_jwt_auth_backend.gitlab.path
  user_claim     = "email"
  role_name      = local.gitlab_default_role_name
  token_policies = var.default_token_policies
  oidc_scopes    = ["profile", "email"]

  bound_audiences = [vault_jwt_auth_backend.gitlab.oidc_client_id]

  allowed_redirect_uris = [
    "https://${var.vault_domain}/ui/vault/auth/${vault_jwt_auth_backend.gitlab.path}/oidc/callback",
    "http://localhost:8250/oidc/callback",
  ]

}
