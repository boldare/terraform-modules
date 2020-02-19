# AWS Bastion Instance  
This module creates Auto-Scaling Group containing a single EC2 instance with public IP.  
The instance can access all other instances in a VPC (Security Groups are preconfigured).  
User Data script is parametrizable and it's output is logged to `/var/log/user-data.log` by default.  
One can use `aws-s3-authorized-keys` module in order to be able to manage SSH keys that have access to the instance.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_user\_data | Scripts to be ran when instance boots up. | `string` | `""` | no |
| allowed\_cidr\_blocks | Determines what CIDRs (i.e. 18.202.145.21/32) can connect to the bastion instance. | `list(string)` | `[]` | no |
| ami\_id | Amazon Machine Image identifier. You can use data.aws\_ami to find the right image. | `string` | n/a | yes |
| egress\_security\_groups | Egress | `list(string)` | `[]` | no |
| enable\_monitoring | Whether to enable EC2 instance monitoring. | `bool` | `false` | no |
| extra\_tags | AWS Tags that will be added to running bastion instance. | <pre>list(object({<br>    key                 = string<br>    value               = string<br>    propagate_at_launch = bool<br>  }))</pre> | `[]` | no |
| instance\_type | Type of EC2 instance. | `string` | `"t3.nano"` | no |
| name | Name of bastion instance and a prefix for it's dependencies | `string` | n/a | yes |
| ssh\_key\_name | Name of SSH key present in AWS EC2 keys list. | `string` | n/a | yes |
| volume\_size | Root volume size in GB. | `number` | `8` | no |
| vpc\_id | Identifier of VPC where the bastion instance is placed. | `string` | n/a | yes |
| vpc\_public\_subnet\_tags | Amazon Tag used to detect public VPC subnets. Used to determine the right subnets to put bastion instance in. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_iam\_role | Bastion IAM role identifier. Can be used to attach additional IAM policies to it. |
| bastion\_security\_group\_id | Bastion Security Group identifier. Can be used to allow broader access to bastion instance. |

