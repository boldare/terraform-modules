output "secrets_map" {
  value       = local.secret_arn_map
  description = "type map variable with `name_of_secret = SecretARN`"
}
output "ssm_tuple" {
  value       = aws_ssm_parameter.secret_ext
  description = "tuple with all SSM secret `ssm_turple[name_of_secret]`"
}