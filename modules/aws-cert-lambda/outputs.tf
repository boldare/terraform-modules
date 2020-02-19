output "lambda_arn" {
  value       = aws_lambda_function.certbot.arn
  description = "ARN of Lambda Function"
}

output "lambda_iam_role_arn" {
  value       = aws_iam_role.lambda.arn
  description = "ARN of Lambda's IAM Role, that has all required policies in place."
}
