output "integration_iam_role" {
  value = aws_iam_role.datadog_integration.name
}

output "lambda_iam_role" {
  value = aws_iam_role.datadog_lambda.id
}

output "lambda_arn" {
  value = aws_lambda_function.datadog.arn
}
