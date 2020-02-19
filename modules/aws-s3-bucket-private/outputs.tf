output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "bucket_policy_arn" {
  value = aws_iam_policy.bucket_policy.arn
}
