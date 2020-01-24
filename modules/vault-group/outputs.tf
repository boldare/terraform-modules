output "environment_read_group_ids" {
  value = vault_identity_group.environment_read[*].id
}

output "environment_manage_group_ids" {
  value = vault_identity_group.environment_manage[*].id
}

output "environment_read_policies" {
  value = zipmap([
  for name in vault_policy.environment_read[*].name:
  split("/", name)[1]
  ], vault_policy.environment_read[*].id)
}

output "environment_manage_policies" {
  value = zipmap([
  for name in vault_policy.environment_manage[*].name:
  split("/", name)[1]
  ], vault_policy.environment_manage[*].id)
}
