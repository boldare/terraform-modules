# AWS one Secret Manager to many SSM secrets
Creates from ont Secret Manager entry many SSM secrets.
Useful for adding external secrets to ECS.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0, < 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.secret_ext](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_secretsmanager_secret_version.secret_ext](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_secret_arn"></a> [external\_secret\_arn](#input\_external\_secret\_arn) | ARN of SecretManager secret entry | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | prefix used in SSM secrets | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secrets_map"></a> [secrets\_map](#output\_secrets\_map) | type map variable with `name_of_secret = SecretARN` |
| <a name="output_ssm_tuple"></a> [ssm\_tuple](#output\_ssm\_tuple) | tuple with all SSM secret `ssm_turple[name_of_secret]` |
