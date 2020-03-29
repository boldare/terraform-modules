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

module "waf" {
  source = "../../aws-waf"

  name          = "my-app"
  allowed_cidrs = [
    "127.0.0.1/32" # Put your VPN IP here
  ]
}

# The example below contains all possible options enabled.
# Some of these options are set to default values.
module "frontend" {
  source    = "../"
  providers = {
    aws             = aws
    aws.global      = aws.global
    aws.hosted_zone = aws.hosted_zone
  }

  enabled                         = true
  create_distribution_dns_records = true

  name                         = "my-app"
  domain_name                  = "my-app.com"
  alternative_domain_names     = [
    "www.my-app.com",
    "web.my-app.com"
  ]
  hosted_zone_id               = "Z24109WKUFE167"
  wait_for_deployment          = false
  cache_disabled_path_patterns = [
    "index.html",
    "/service-worker.js"
  ]
  web_acl_id                   = module.waf.web_acl_id # Limit access to set of CIDRs

  content_security_policy = {
    "default-src" = "'self' blob: https://*.my-app.com https://*.hotjar.com https://*.hotjar.io https://*.youtube.com https://*.ytimg.com https://firestore.googleapis.com"
    "font-src"    = "'self' https://fonts.googleapis.com"
    "img-src"     = "'self' https://www.google.com https://www.google-analytics.com https://*.ytimg.com"
    "object-src"  = "'none'"
    "script-src"  = "'self' 'unsafe-inline' 'unsafe-eval' https://*.my-app.com https://www.google-analytics.com https://*.hotjar.com https://*.hotjar.io https://*.youtube.com https://*.ytimg.com"
    "style-src"   = "'self' 'unsafe-inline'"
    "worker-src"  = "blob:"
  }

  custom_headers = {
    "X-Frame-Options" = "" # Override default "deny" header
  }

  lambda_log_retention_in_days = 14

  edge_functions               = {
    redirections = {
      event_type     = "origin-request"
      include_body   = false
      lambda_code    = file("${path.module}/redirections.js")
      lambda_runtime = "nodejs12.x"
    }
  }

  comment = "MyApp Frontend"
  tags    = {
    Name        = "MyApp"
    Environment = "Production"
  }
}

data "aws_iam_policy_document" "redirections_lambda" {
  # Custom policy for redirections lambda function passed to frontend module
}

resource "aws_iam_role_policy" "redirections_lambda" {
  policy = data.aws_iam_policy_document.redirections_lambda.json
  role   = module.frontend.edge_function_roles["redirections"]
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
