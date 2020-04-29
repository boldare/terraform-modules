output "ids" {
  value       = local.ids
  description = "User names mapped to their identifiers in Vault."
}

output "users" {
  value       = var.users
  description = "User names mapped to their emails (same as 'users' input variable)."
}
