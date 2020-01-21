# aws_iam_user_group

This module creates IAM user group, attaches users and policies to it.

## Usage

```hcl-terraform
module "developers" {
  source = "../../modules/aws_iam_user_group"

  name                 = "Developers"
  attached_policy_arns = [
    module.authorization_policy.mfa_policy_arn,
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
  users                = [
    "developer-iam-user-1",
    "developer-iam-user-2"
  ]
}
```
