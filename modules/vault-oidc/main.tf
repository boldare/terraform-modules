/**
 * # Vault OIDC
 * This module creates Vault JWT Auth Backend, which allows you to log in to Vault
 * using well-known services you already use.
 *
 * For instance, you may configure this module to let you in to vault after
 * authorizing via GitLab or Google account.
 */

locals {
  time_units = ["d", "h", "m", "s"]

  max_ttl_s     = var.max_ttl % 60
  max_ttl_m     = ((var.max_ttl - local.max_ttl_s) / 60) % 60
  max_ttl_h     = ((var.max_ttl - local.max_ttl_m * 60 - local.max_ttl_s) / 3600) % 24
  max_ttl_d     = ((var.max_ttl - local.max_ttl_h * 3600 - local.max_ttl_m * 60 - local.max_ttl_s) / 24 * 3600)
  max_ttl_parts = [local.max_ttl_d, local.max_ttl_h, local.max_ttl_m, local.max_ttl_s]
  max_ttl = join("", [
    for i in range(length(local.time_units)) : (local.max_ttl_parts[i] > 0 ? "${local.max_ttl_parts[i]}${local.time_units[i]}" : "")
  ])

  default_ttl_s     = var.default_ttl % 60
  default_ttl_m     = ((var.default_ttl - local.default_ttl_s) / 60) % 60
  default_ttl_h     = ((var.default_ttl - local.default_ttl_m * 60 - local.default_ttl_s) / 3600) % 24
  default_ttl_d     = ((var.default_ttl - local.default_ttl_h * 3600 - local.default_ttl_m * 60 - local.default_ttl_s) / 24 * 3600)
  default_ttl_parts = [local.default_ttl_d, local.default_ttl_h, local.default_ttl_m, local.default_ttl_s]
  default_ttl = join("", [
    for i in range(length(local.time_units)) : (local.default_ttl_parts[i] > 0 ? "${local.default_ttl_parts[i]}${local.time_units[i]}" : "")
  ])
}

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
    default_lease_ttl  = local.default_ttl
    max_lease_ttl      = local.max_ttl
    token_type         = "default-service"
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

  token_ttl              = var.default_ttl
  token_max_ttl          = var.max_ttl
  token_explicit_max_ttl = var.max_ttl

  bound_audiences       = [vault_jwt_auth_backend.this.oidc_client_id]
  allowed_redirect_uris = concat(local.vault_addresses, ["http://localhost:8250/oidc/callback"])
}
