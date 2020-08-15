# AWS Generate Cert  
Simple module creating SSL certificate for domain including all necessary Route53 records .

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.49, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.49, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain | Domain for which certificate is going to be created | `string` | n/a | yes |
| zone\_id | Route53 zone id. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | n/a |

