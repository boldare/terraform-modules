output "s3_bucket" {
  value       = var.enabled ? aws_s3_bucket.bucket[0].id : null
  description = "S3 Bucket Name"
}

output "s3_bucket_arn" {
  value       = var.enabled ? aws_s3_bucket.bucket[0].arn : null
  description = "S3 Bucket ARN"
}

output "cf_distribution_id" {
  value       = var.enabled ? aws_cloudfront_distribution.distribution[0].id : null
  description = "CloudFront Distribution ID"
}

output "deployer_policy_arn" {
  value       = var.enabled ? aws_iam_policy.deployer[0].arn : null
  description = "Policy that allows for performing S3 bucket actions & CloudFront invalidation."
}

output "edge_function_roles" {
  value       = var.enabled ? {
  for key, value in aws_iam_role.edge_lambda_custom: key => value.id
  } : {
  for key, value in var.edge_functions: key => null
  }
  description = "Map of IAM role ids for custom Lambda@Edge functions passed to module."
}
