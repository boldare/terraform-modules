output "s3_bucket" {
  value = aws_s3_bucket.bucket.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "cf_distribution_id" {
  value = aws_cloudfront_distribution.distribution.id
}

output "deployer_policy_arn" {
  value = aws_iam_policy.deployer.arn
}
