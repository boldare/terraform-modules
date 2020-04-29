output "environments" {
  value = var.environments
}

output "environment_read_group_ids" {
  value = {
    for key, group in vault_identity_group.environment_read :
    key => group.id
  }
}

output "environment_manage_group_ids" {
  value = {
    for key, group in vault_identity_group.environment_manage :
    key => group.id
  }
}

output "environment_read_policies" {
  value = {
    for policy in vault_policy.environment_read :
    split("/", policy.name)[1] => policy.id
  }
}

output "environment_manage_policies" {
  value = {
    for policy in vault_policy.environment_manage :
    split("/", policy.name)[1] => policy.id
  }
}
