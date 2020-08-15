output "load_balancing_policy_arn" {
  value       = length(aws_iam_policy.load_balancing) > 0 ? aws_iam_policy.load_balancing[0].arn : null
  description = "ARN for Load Balancing IAM policy."
}

output "autoscaling_policy_arn" {
  value       = length(aws_iam_policy.autoscaling) > 0 ? aws_iam_policy.autoscaling[0].arn : null
  description = "ARN for Autoscaling IAM policy."
}

output "dns_policy_arn" {
  value       = length(aws_iam_policy.dns) > 0 ? aws_iam_policy.dns[0].arn : null
  description = "ARN for DNS IAM policy."
}
