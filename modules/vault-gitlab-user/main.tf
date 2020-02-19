locals {
  id = length(data.vault_identity_entity.this) > 0 ? data.vault_identity_entity.this[0].id : length(vault_identity_entity.this) > 0 ? vault_identity_entity.this[0].id : ""
}

resource "vault_identity_entity" "this" {
  count = var.existing_user ? 0 : 1

  name              = var.name
  external_policies = true
}

resource "vault_identity_entity_alias" "gitlab" {
  count = var.existing_user ? 0 : 1

  canonical_id   = local.id
  mount_accessor = var.gitlab_accessor
  name           = var.email
}

data "vault_identity_entity" "this" {
  count = var.existing_user ? 1 : 0

  entity_name = var.name
}
