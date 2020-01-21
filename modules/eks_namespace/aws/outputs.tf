output "cluster_policy_arn" {
  value = aws_iam_policy.cluster_policy.arn
}

output "s3_policy_arn" {
  value = aws_iam_policy.s3_policy.arn
}

output "s3_read_policy_arn" {
  value = aws_iam_policy.s3_read_policy.arn
}

output "ecr_policy_arn" {
  value = aws_iam_policy.ecr_policy.arn
}

output "ecr_read_policy_arn" {
  value = aws_iam_policy.ecr_read_policy.arn
}
