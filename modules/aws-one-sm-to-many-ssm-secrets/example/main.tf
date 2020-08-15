provider "aws" {
  version = "~>3.0"
  region  = "us-east-1"
}

resource "aws_secretsmanager_secret" "external_secret" {
  name = "boldare-secret-secrets/external"
}

# ^ Has to be done first first

module "secrets" {
  source              = "../"
  external_secret_arn = aws_secretsmanager_secret.external_secret.arn
  name                = "MagicalSecrets"
}
