# aws_authorization

This module creates IAM password policy for AWS account, which:
 - enforces usage of strong passwords
 - requires password rotation every X days

It also creates IAM policy which blocks all actions if user is not authorized using MFA.

## Usage

```hcl-terraform
module "authorization_policy" {
  source = "../../modules/aws_authorization"

  max_password_age = 120
  minimum_password_length = 24
  use_various_characters = false
}

```
