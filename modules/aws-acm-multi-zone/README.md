# AWS Generate multi zone cert  
Module for creating SSL certificate for multiple domains in different route53 zones (eg. different TLD domains).  
Limitation: Wildcard domains.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| certificates | A mapping of hosted zone name to domains. | `map(list(string))` | n/a | yes |
| tags | Tags to be added to ACM. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | ARN of ACM certificate |
| list\_of\_domains | Domains that ACM certificate was created for |

