# AWS one Secret Manager to many SSM secrets  
Creates from ont Secret Manager entry many SSM secrets.  
Useful for add external secrets to ECS.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| external\_secret\_arn | ARN of SecretManager secret entry | `string` | n/a | yes |
| name | prefix used in SSM secrets | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| secrets\_map | type map variable with `name_of_secret = SecretARN` |
| ssm\_tuple | tuple with all SSM secret `ssm_turple[name_of_secret]` |

