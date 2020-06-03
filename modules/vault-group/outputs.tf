output "environments" {
  value       = var.environments
  description = "Environments variable passthrough."
}

output "secret_engine_paths" {
  value       = local.secret_engine_paths
  description = "Environments variable, but without Secret Engine types. For example kv = [\"kv2\", \"kv\"] becomes just kv = \"kv\""
}

output "group_ids" {
  value = {
    for key, group in vault_identity_group.groups :
    key => group.id
  }
}

output "policy_ids" {
  value = {
    for key, policy in vault_policy.policies :
    key => policy.id
  }
}
