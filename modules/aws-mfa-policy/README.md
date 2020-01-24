# aws_authorization

This module creates IAM password policy for AWS account, which:
 - enforces usage of strong passwords
 - requires password rotation every X days

It also creates IAM policy which blocks all actions if user is not authorized using MFA.

## Usage

```hcl-terraform
module "authorization_policy" {
  source = "github.com/boldare/terraform-modules//modules/aws-mfa-policy?ref=v0.1.0"

  name                             = "Authorization"
  authorization_policy_path_prefix = "people/"
}
```
