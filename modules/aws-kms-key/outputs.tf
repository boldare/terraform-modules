output "kms_key_id" {
  value = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.this.arn
}

output "iam_user_policy_arn" {
  value = aws_iam_policy.user.arn
}

output "iam_admin_policy_arn" {
  value = aws_iam_policy.admin.arn
}
