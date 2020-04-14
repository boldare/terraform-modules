# AWS generate cert  
Simple module creating SSL certificate for domain including all necessary Route53 records .

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain | Domain for which certificate is going to be created | `string` | n/a | yes |
| zone\_id | Route53 zone id. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | n/a |

