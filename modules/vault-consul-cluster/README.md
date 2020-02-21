## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ami\_id | The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under components/vault-ami/vault-consul.json. | `string` | n/a | yes |
| aws\_region | n/a | `string` | n/a | yes |
| cert\_refresh\_cron | CRON expresstion that determines when Vault should restart in order to refresh TLS certificates. Defaults to 12 hours | `string` | `"0 0,12 * * *"` | no |
| cert\_s3\_bucket\_name | Name of S3 bucket which will be used to store TLS certificates and Vault unseal keys | `string` | n/a | yes |
| cert\_s3\_bucket\_tls\_cert\_file | Path to TLS certificate file | `string` | n/a | yes |
| cert\_s3\_bucket\_tls\_key\_file | Path to TLS key file | `string` | n/a | yes |
| consul\_additional\_user\_data | n/a | `string` | `""` | no |
| consul\_cluster\_name | What to name the Consul server cluster and all of its associated resources | `string` | n/a | yes |
| consul\_cluster\_size | The number of Consul server nodes to deploy. We strongly recommend using 3 or 5. | `number` | n/a | yes |
| consul\_cluster\_tag\_key | The tag the Consul EC2 Instances will look for to automatically discover each other and form a cluster. | `string` | n/a | yes |
| consul\_instance\_type | The type of EC2 Instance to run in the Consul ASG | `string` | n/a | yes |
| create\_dns\_entry | If set to true, this module will create a Route 53 DNS A record for the ELB in the var.hosted\_zone\_id hosted zone with the domain name in var.vault\_domain\_name. | `bool` | `false` | no |
| hosted\_zone\_id | n/a | `string` | n/a | yes |
| s3\_backend\_admin\_arns | Roles or user that should have access to files on Vault's S3 backend | `list(string)` | `[]` | no |
| ssh\_key\_name | The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair. | `string` | n/a | yes |
| ssh\_security\_group\_ids | Bastion Host Security Group Ids - to allow SSH access to Vault/Consul machines | `list(string)` | `[]` | no |
| vault\_additional\_user\_data | n/a | `string` | `""` | no |
| vault\_cluster\_name | What to name the Vault server cluster and all of its associated resources | `string` | n/a | yes |
| vault\_cluster\_size | The number of Vault server nodes to deploy. We strongly recommend using 3 or 5. | `number` | n/a | yes |
| vault\_domain\_name | The domain name to use in the DNS A record for the Vault ELB (e.g. vault.example.com). Make sure that a) this is a domain within the var.hosted\_zone\_domain\_name hosted zone and b) this is the same domain name you used in the TLS certificates for Vault. Only used if var.create\_dns\_entry is true. | `string` | n/a | yes |
| vault\_instance\_type | The type of EC2 Instance to run in the Vault ASG | `string` | n/a | yes |
| vpc\_id | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| asg\_name\_consul\_cluster | n/a |
| asg\_name\_vault\_cluster | n/a |
| consul\_gossip\_key | n/a |
| consul\_sg\_id | n/a |
| iam\_role\_arn\_consul\_cluster | n/a |
| iam\_role\_arn\_vault\_cluster | n/a |
| iam\_role\_id\_consul\_cluster | n/a |
| iam\_role\_id\_vault\_cluster | n/a |
| launch\_config\_name\_consul\_cluster | n/a |
| launch\_config\_name\_vault\_cluster | n/a |
| s3\_bucket\_arn | n/a |
| security\_group\_id\_consul\_cluster | n/a |
| security\_group\_id\_vault\_cluster | n/a |
| ssh\_key\_name | n/a |
| vault\_cluster\_size | n/a |
| vault\_elb\_dns\_name | n/a |
| vault\_fully\_qualified\_domain\_name | n/a |
| vault\_servers\_cluster\_tag\_key | n/a |
| vault\_servers\_cluster\_tag\_value | n/a |
| vault\_sg\_id | n/a |

