output "namespace" {
  value = kubernetes_namespace.namespace.metadata[0].name
}

output "ci_user" {
  value = var.create_ci_iam_user ? aws_iam_user.ci[0].id : null
}

output "ci_user_arn" {
  value = var.create_ci_iam_user ? aws_iam_user.ci[0].arn : null
}

# ----------------------
# ADMINISTRATORS GROUP
# ----------------------

output "administrators_group" {
  value       = module.administrators.iam_group
  description = "AWS IAM group name for administrators group."
}

output "administrator_role" {
  value       = module.administrators.iam_role
  description = "AWS IAM role ID with all necessary permissions for managing Kubernetes, assumable by administrators group."
}

output "administrators_aws_auth_entry" {
  value       = module.administrators.aws_auth_entry
  description = "An IAM-Kubernetes binding for administrators group, that has to be put to 'aws-auth' ConfigMap."
}

output "administrators_iam_policies" {
  value       = local.administrators_iam_policies
  description = "All AWS IAM policies assigned to administrators group."
}

output "administrators_kubernetes_role" {
  value       = module.administrators.kubernetes_role
  description = "Kubernetes role for administrators IAM group. Can be used in 'aws-auth' ConfigMap as 'username' entry."
}

output "administrators_kubernetes_group" {
  value       = module.administrators.kubernetes_group
  description = "Kubernetes group for administrators IAM group. Can be used in 'aws-auth' ConfigMap as element of 'groups' entry."
}

# ----------------------
# DEVELOPERS GROUP
# ----------------------

output "developers_group" {
  value       = module.administrators.iam_group
  description = "AWS IAM group name for developers group."
}

output "developer_role" {
  value       = module.developers.iam_role
  description = "AWS IAM role ID with all necessary permissions for monitoring Kubernetes, assumable by developers group."
}

output "developers_aws_auth_entry" {
  value       = module.developers.aws_auth_entry
  description = "An IAM-Kubernetes binding for developers group, that has to be put to 'aws-auth' ConfigMap."
}

output "developers_iam_policies" {
  value       = local.developers_iam_policies
  description = "All AWS IAM policies assigned to developers group."
}

output "developers_kubernetes_role" {
  value       = module.developers.kubernetes_role
  description = "Kubernetes role for developers IAM group. Can be used in 'aws-auth' ConfigMap as 'username' entry."
}

output "developers_kubernetes_group" {
  value       = module.developers.kubernetes_group
  description = "Kubernetes group for developers IAM group. Can be used in 'aws-auth' ConfigMap as element of 'groups' entry."
}
