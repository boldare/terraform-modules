output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}

output "c" {
  value = module.eks.kubeconfig
}
