output "namespace" {
  value = kubernetes_namespace.namespace.metadata[0].name
}

output "administrators_group" {
  value = module.administrators.iam_group
}

output "administrator_role" {
  value = module.administrators.iam_role
}

output "administrators_aws_auth_entry" {
  value = module.administrators.aws_auth_entry
}

output "administrators_iam_policies" {
  value = local.administrators_iam_policies
}

output "developers_group" {
  value = module.administrators.iam_group
}

output "developer_role" {
  value = module.developers.iam_role
}

output "developers_aws_auth_entry" {
  value = module.developers.aws_auth_entry
}

output "developers_iam_policies" {
  value = local.developers_iam_policies
}

output "ci_user" {
  value = var.create_ci_iam_user ? aws_iam_user.ci[0].id : null
}

output "ci_user_arn" {
  value = var.create_ci_iam_user ? aws_iam_user.ci[0].arn : null
}
