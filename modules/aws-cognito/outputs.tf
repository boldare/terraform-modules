output "user_pool_id" {
  value = aws_cognito_user_pool.pool.id
  description = "Identifier of created Cognito User Pool."
}

output "user_pool_arn" {
  value = aws_cognito_user_pool.pool.arn
  description = "ARN of created Cognito User Pool."
}

output "user_pool_policy_arn" {
  value = aws_iam_policy.user_pool.arn
  description = "IAM policy that can be applied to roles and users which will manage this User Pool."
}
