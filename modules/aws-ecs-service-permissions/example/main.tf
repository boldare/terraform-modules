module "app_role" {
  source = "../"

  name              = "boldare-dev"
  attached_policies = [aws_iam_policy.example.arn]
  secret_arns       = [aws_secretsmanager_secret.app_secret.arn]

}

# Secret

resource "random_password" "app_secret" {
  length = 50
}

resource "aws_secretsmanager_secret" "app_secret" {
  name = "boldare/app"
}

resource "aws_secretsmanager_secret_version" "app_secret_v1" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = random_password.app_secret.result
}

# policy

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "example" {
  name   = "example_policy"
  policy = data.aws_iam_policy_document.example.json
}

