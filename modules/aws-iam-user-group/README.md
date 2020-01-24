# AWS IAM User Group

This module creates IAM user group, attaches users and policies to it.

## Usage

```hcl-terraform
module "developers" {
  source = "github.com/boldare/terraform-modules//modules/aws-iam-user-group?ref=v0.1.0"

  name                 = "Developers"
  attached_policy_arns = [
    module.authorization_policy.policy_arn,
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
  users                = [
    "developer-iam-user-1",
    "developer-iam-user-2"
  ]
}
```
