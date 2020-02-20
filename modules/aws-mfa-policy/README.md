# AWS Multi-Factor Authentication Policy

This module creates IAM policy which blocks all actions if user is not authenticated using MFA.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| authorization\_policy\_path\_prefix | Path that applies to all users in authorization policy. Must end with '/'. It's used to create Resource like 'arn:aws:iam::\*:user/authorization\_policy\_path\_prefix/${aws:username}'. | `string` | `""` | no |
| name | Policy name | `string` | `"Authorization"` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy\_arn | n/a |

