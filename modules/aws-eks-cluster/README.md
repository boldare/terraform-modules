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
| node\_groups | Managed EKS Node Groups: Map of map of node groups to create. | `any` | `{}` | no |
| node\_groups\_defaults | Managed EKS Node Groups Defaults: Map of values to be applied to all node groups. | `any` | `{}` | no |
| region | n/a | `string` | n/a | yes |
| subnets | n/a | `list(string)` | n/a | yes |
| vpc\_id | n/a | `string` | n/a | yes |
| worker\_groups | n/a | `any` | `[]` | no |
| worker\_groups\_launch\_template | n/a | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch\_log\_group\_name | Name of cloudwatch log group created |
| cluster\_arn | The Amazon Resource Name (ARN) of the cluster. |
| cluster\_certificate\_authority\_data | Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster. |
| cluster\_endpoint | The endpoint for your EKS Kubernetes API. |
| cluster\_iam\_role\_arn | IAM role ARN of the EKS cluster. |
| cluster\_iam\_role\_name | IAM role name of the EKS cluster. |
| cluster\_id | The name/id of the EKS cluster. |
| cluster\_oidc\_issuer\_url | The URL on the EKS cluster OIDC Issuer |
| cluster\_security\_group\_id | Security group ID attached to the EKS cluster. |
| cluster\_version | The Kubernetes server version for the EKS cluster. |
| config\_map\_aws\_auth | A kubernetes configuration to authenticate to this EKS cluster. |
| kubeconfig | kubectl config file contents for this EKS cluster. |
| kubeconfig\_filename | The filename of the generated kubectl config. |
| node\_groups | Outputs from EKS node groups. Map of maps, keyed by var.node\_groups keys |
| oidc\_provider\_arn | The ARN of the OIDC Provider if `enable_irsa = true`. |
| worker\_iam\_instance\_profile\_arns | default IAM instance profile ARN for EKS worker groups |
| worker\_iam\_instance\_profile\_names | default IAM instance profile name for EKS worker groups |
| worker\_iam\_role\_arn | default IAM role ARN for EKS worker groups |
| worker\_iam\_role\_name | default IAM role name for EKS worker groups |
| worker\_security\_group\_id | Security group ID attached to the EKS workers. |
| workers\_asg\_arns | IDs of the autoscaling groups containing workers. |
| workers\_asg\_names | Names of the autoscaling groups containing workers. |
| workers\_default\_ami\_id | ID of the default worker group AMI |
| workers\_launch\_template\_arns | ARNs of the worker launch templates. |
| workers\_launch\_template\_ids | IDs of the worker launch templates. |
| workers\_launch\_template\_latest\_versions | Latest versions of the worker launch templates. |
| workers\_user\_data | User data of worker groups |

