output "namespace" {
  value = kubernetes_namespace.namespace.metadata[0].name
}

output "administrators_group" {
  value = module.administrators.iam_group
}

output "administrators_aws_auth_entry" {
  value = module.administrators.aws_auth_entry
}

output "developers_group" {
  value = module.administrators.iam_group
}

output "developers_aws_auth_entry" {
  value = module.developers.aws_auth_entry
}

output "ci_user" {
  value = aws_iam_user.ci.id
}

output "ci_user_arn" {
  value = aws_iam_user.ci.arn
}
