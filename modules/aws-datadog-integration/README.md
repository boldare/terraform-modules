# AWS Datadog Integration  
Creates lambda function, role & policies necessary to run full Datadog monitoring for AWS account.  
Source code for Lambda can be found at [DataDog/datadog-serverless-functions](https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring) repository.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_key | The Datadog API key associated with your Datadog Account. | `string` | n/a | yes |
| aws\_account\_external\_id | AWS External Account ID sets a limit on who can access monitoring on your account. It's generated during AWS Datadog integration setup. | `string` | n/a | yes |
| aws\_region | AWS region to place lambda in. Can be obtained from data.aws\_region. | `string` | n/a | yes |
| site | Set it to datadoghq.eu for Datadog EU site. | `string` | `"datadoghq.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| integration\_iam\_role | n/a |
| lambda\_arn | n/a |
| lambda\_iam\_role | n/a |

