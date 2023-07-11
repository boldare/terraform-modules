# AWS Multi-Factor Authentication Policy

This module creates IAM policy which blocks all actions if user is not authenticated using MFA.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.authorization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.authorization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorization_policy_path_prefix"></a> [authorization\_policy\_path\_prefix](#input\_authorization\_policy\_path\_prefix) | Path that applies to all users in authorization policy. Must end with '/'. It's used to create Resource like 'arn:aws:iam::*:user/authorization\_policy\_path\_prefix/${aws:username}'. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Policy name | `string` | `"Authorization"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | n/a |
