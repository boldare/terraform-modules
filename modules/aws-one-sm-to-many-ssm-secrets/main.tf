/**
 * # AWS one Secret Manager to many SSM secrets
 * Creates from ont Secret Manager entry many SSM secrets.
 * Useful for adding external secrets to ECS.
 */

data "aws_secretsmanager_secret_version" "secret_ext" {
  secret_id = var.external_secret_arn
}

resource "aws_ssm_parameter" "secret_ext" {
  for_each = jsondecode(data.aws_secretsmanager_secret_version.secret_ext.secret_string)

  name  = "/${var.name}/${each.key}"
  type  = "SecureString"
  value = each.value
}

locals {
  secret_arn_map = {
    for key, value in jsondecode(data.aws_secretsmanager_secret_version.secret_ext.secret_string) :
    key => aws_ssm_parameter.secret_ext[key].arn
  }
}
