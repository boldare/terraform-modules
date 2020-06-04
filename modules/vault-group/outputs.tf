output "environments" {
  value       = var.environments
  description = "Environments variable passthrough."
}

output "secret_engine_paths" {
  value       = local.secret_engine_paths
  description = "Environments variable, but without Secret Engine types. For example kv = [\"kv2\", \"kv\"] becomes just kv = \"kv\""
}

output "policies" {
  value       = vault_policy.policies
  description = "All Vault policies created by this module."
}

output "groups" {
  value       = vault_identity_group.groups
  description = "All Vault groups created by this module."
}

output "group_ids" {
  value = {
    for key, group in vault_identity_group.groups :
    key => group.id
  }
  description = "Map containing all groups mapped to their IDs in Vault."
}

output "policy_ids" {
  value = {
    for key, policy in vault_policy.policies :
    key => policy.id
  }
  description = "Map containing all policies mapped to their IDs in Vault."
}

output "group_policies" {
  value = {
    for key, group in vault_identity_group.groups :
    key => group.policies
  }
  description = "Map containing group names mapped to list of policies of each group."
}
