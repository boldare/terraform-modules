provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "global"
  region = "us-east-1"
}

provider "aws" {
  alias  = "hosted_zone"
  region = "eu-west-1"
}

module "frontend" {
  source    = "../"
  providers = {
    aws             = aws
    aws.global      = aws.global
    aws.hosted_zone = aws.hosted_zone
  }

  name           = "my-app"
  domain_name    = "my-app.com"
  hosted_zone_id = "Z24109WKUFE167"
}

# ------------------------------------
# CI USER FOR AUTOMATED DEPLOYMENTS
# ------------------------------------

resource "aws_iam_user" "ci" {
  name = "my-app-ci"
}

resource "aws_iam_user_policy_attachment" "ci_frontend_policy" {
  policy_arn = module.frontend.deployer_policy_arn
  user       = aws_iam_user.ci.id
}

resource "aws_iam_access_key" "ci" {
  user = aws_iam_user.ci.id
}

# ------------------------------------
# OUTPUTS
# ------------------------------------

output "aws_access_key_id" {
  value = aws_iam_access_key.ci.id
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.ci.secret
  sensitive = true
}

output "s3_bucket" {
  value = module.frontend.s3_bucket
}

output "cf_distribution_id" {
  value = module.frontend.cf_distribution_id
}
