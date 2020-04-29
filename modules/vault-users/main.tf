/**
 * # Vault Users
 * This module creates entities in Vault that are automatically connected to aliases for specified auth backend.
 * You can use it to create list of users that can log in to Vault using OpenID Connect, i.e. via Google or GitLab.
 *
 */

locals {
  ids = {
    for key, entity in vault_identity_entity.this :
    key => entity.id
  }
}

resource "vault_identity_entity" "this" {
  for_each = var.users

  name              = each.key
  external_policies = true
}

resource "vault_identity_entity_alias" "this" {
  for_each = var.users

  canonical_id   = local.ids[each.key]
  mount_accessor = var.auth_backend_accessor
  name           = each.value
}
