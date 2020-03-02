output "s3_bucket" {
  value       = aws_s3_bucket.bucket.id
  description = "S3 Bucket Name"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "S3 Bucket ARN"
}

output "cf_distribution_id" {
  value       = aws_cloudfront_distribution.distribution.id
  description = "CloudFront Distribution ID"
}

output "deployer_policy_arn" {
  value       = aws_iam_policy.deployer.arn
  description = "Policy that allows for performing S3 bucket actions & CloudFront invalidation."
}
