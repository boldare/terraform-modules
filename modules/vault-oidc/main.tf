/**
 * # Vault OIDC
 * This module creates Vault JWT Auth Backend, which allows you to log in to Vault
 * using well-known services you already use.
 *
 * For instance, you may configure this module to let you in to vault after
 * authorizing via GitLab or Google account.
 */

resource "vault_jwt_auth_backend" "this" {
  description        = var.description
  path               = var.path
  type               = "oidc"
  oidc_discovery_url = "https://${var.domain}"
  oidc_client_id     = var.client_id
  oidc_client_secret = var.client_secret
  bound_issuer       = var.domain
  default_role       = var.role_name

  tune {
    listing_visibility = "unauth"
    default_lease_ttl  = "${var.ttl}s"
    max_lease_ttl      = "${var.ttl}s"
  }

  lifecycle {
    ignore_changes = [description]
  }
}

locals {
  vault_addresses = [
    for domain in var.vault_domains :
    "https://${domain}/ui/vault/auth/${vault_jwt_auth_backend.this.path}/oidc/callback"
  ]
}

resource "vault_jwt_auth_backend_role" "this" {
  role_type      = "oidc"
  backend        = vault_jwt_auth_backend.this.path
  user_claim     = "email"
  role_name      = var.role_name
  token_policies = var.default_token_policies
  oidc_scopes    = var.scopes

  token_ttl              = var.ttl
  token_max_ttl          = var.ttl
  token_explicit_max_ttl = var.ttl

  bound_audiences       = [vault_jwt_auth_backend.this.oidc_client_id]
  allowed_redirect_uris = concat(local.vault_addresses, ["http://localhost:8250/oidc/callback"])
}
