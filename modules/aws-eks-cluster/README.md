## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| admin\_iam\_roles | ARN Users that have admin access to the cluster | `list(string)` | `[]` | no |
| admin\_iam\_users | ARN Users that have admin access to the cluster | `list(string)` | `[]` | no |
| aws\_profile | n/a | `string` | n/a | yes |
| cluster\_name | n/a | `string` | n/a | yes |
| cluster\_version | n/a | `string` | n/a | yes |
| map\_roles | n/a | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | n/a | yes |
| node\_groups | Managed EKS Node Groups | `any` | n/a | yes |
| node\_groups\_defaults | Managed EKS Node Groups Defaults | `any` | n/a | yes |
| region | n/a | `string` | n/a | yes |
| subnets | n/a | `list(string)` | n/a | yes |
| vpc\_id | n/a | `string` | n/a | yes |
| worker\_groups | n/a | `any` | `[]` | no |
| worker\_groups\_launch\_template | n/a | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| c | n/a |
| worker\_iam\_role\_arn | n/a |

