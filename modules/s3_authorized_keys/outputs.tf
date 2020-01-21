output "user_data_chunk" {
  value = data.template_file.user_data_chunk.rendered
}

output "keys_s3_bucket" {
  value = aws_s3_bucket.keys.bucket
}

output "keys_s3_read_only_policy_arn" {
  value = aws_iam_policy.read_only.arn
}
