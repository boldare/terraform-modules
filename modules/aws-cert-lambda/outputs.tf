output "lambda_arn" {
  value = aws_lambda_function.certbot.arn
}

output "lambda_iam_role_arn" {
  value = aws_iam_role.lambda.arn
}
