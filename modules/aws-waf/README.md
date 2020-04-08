# AWS WAF

This module is used to restrict access to a CloudFront distribution based on IP whitelist.  
It creates a Web Application Firewall rule that can be added to an existing CF distribution.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_cidrs | List of whitelisted CIDR address blocks. | `list(string)` | `[]` | no |
| name | n/a | `string` | n/a | yes |
| tags | Tags that will be applied to all underlying resources that support it. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_id | Web Application Firewall service ID limiting access to CloudFront distribution to given IP adresses. |

