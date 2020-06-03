output "environments" {
  value = var.environments
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
