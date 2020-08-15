# AWS EKS Permissions  
Use this module to define a set of standard permissions for your EKS cluster.

This module features the following IAM policies:
- Load Balancing: Allows to create and manage load balancers
- Autoscaling: Allows to scale existing autoscaling groups
- DNS: Allows to modify Route53 records in all hosted zones

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
| autoscaling\_create | Whether to create Autoscaling policy. | `bool` | `false` | no |
| dns\_create | Whether to create DNS policy. | `bool` | `false` | no |
| load\_balancing\_create | Whether to create Load Balancing policy. | `bool` | `false` | no |
| name\_prefix | Name prefix for created policies. No prefix is added by default. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_policy\_arn | ARN for Autoscaling IAM policy. |
| dns\_policy\_arn | ARN for DNS IAM policy. |
| load\_balancing\_policy\_arn | ARN for Load Balancing IAM policy. |

