# AWS EKS Permissions
Use this module to define a set of standard permissions for your EKS cluster.

This module features the following IAM policies:
- Load Balancing: Allows to create and manage load balancers
- Autoscaling: Allows to scale existing autoscaling groups
- DNS: Allows to modify Route53 records in all hosted zones

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
| [aws_iam_policy.autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.load_balancing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.load_balancing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_create"></a> [autoscaling\_create](#input\_autoscaling\_create) | Whether to create Autoscaling policy. | `bool` | `false` | no |
| <a name="input_dns_create"></a> [dns\_create](#input\_dns\_create) | Whether to create DNS policy. | `bool` | `false` | no |
| <a name="input_load_balancing_create"></a> [load\_balancing\_create](#input\_load\_balancing\_create) | Whether to create Load Balancing policy. | `bool` | `false` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for created policies. No prefix is added by default. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_policy_arn"></a> [autoscaling\_policy\_arn](#output\_autoscaling\_policy\_arn) | ARN for Autoscaling IAM policy. |
| <a name="output_dns_policy_arn"></a> [dns\_policy\_arn](#output\_dns\_policy\_arn) | ARN for DNS IAM policy. |
| <a name="output_load_balancing_policy_arn"></a> [load\_balancing\_policy\_arn](#output\_load\_balancing\_policy\_arn) | ARN for Load Balancing IAM policy. |
