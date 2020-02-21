output "iam_group" {
  value = module.group.iam_group
}

output "iam_group_arn" {
  value = module.group.iam_group_arn
}

output "iam_role" {
  value = aws_iam_role.iam_role.id
}

output "kubernetes_role" {
  value = var.kubernetes_role
}

output "kubernetes_namespace" {
  value = var.kubernetes_namespace
}

output "aws_auth_entry" {
  description = "An IAM-Kubernetes binding that has to be put to aws-auth ConfigMap."
  value       = {
    rolearn  = replace(replace(aws_iam_role.iam_role.arn, var.iam_path, ""), "/\\/{2,}/", "/")
    username = var.kubernetes_role
    groups   = [local.kubernetes_group]
  }
}
