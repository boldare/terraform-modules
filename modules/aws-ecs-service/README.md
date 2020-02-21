## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_region | The AWS region things are created in | `string` | n/a | yes |
| az\_count | Number of Availability Zoness to cover in a given region | `number` | `2` | no |
| ecs\_cluster | ECS cluster to run ECS Service in | `string` | n/a | yes |
| environment | Environment Variables for the container | `map(string)` | `{}` | no |
| execution\_role\_arn | Role used by the Fargate to perform actions (Docker pull, logs) | `string` | n/a | yes |
| exposed\_ports | n/a | <pre>map(object({<br>    expose_as    = number<br>    protocol     = string<br>    health_check = any<br>  }))</pre> | n/a | yes |
| fargate\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `number` | `512` | no |
| fargate\_memory | Fargate instance memory to provision (in MiB) | `number` | `1024` | no |
| health\_check\_grace\_period\_seconds | n/a | `number` | `15` | no |
| health\_check\_path | AWS will perform GET requests on this path to determine if service is running | `string` | `"/"` | no |
| image\_tag | ECR image tag to use; if not present, we use busybox | `string` | n/a | yes |
| instance\_count | Number of docker containers to run | `number` | `3` | no |
| internal\_port | n/a | `number` | n/a | yes |
| load\_balancer\_arn | n/a | `string` | n/a | yes |
| name | Name of the app used in ECS | `string` | n/a | yes |
| port | n/a | `number` | n/a | yes |
| port\_mappings | n/a | `map(string)` | n/a | yes |
| repository\_name | ECR repository name | `string` | n/a | yes |
| secrets | AWS Secrets Manager secrets to insert as variables for the container | `map(string)` | `{}` | no |
| sg\_ids | Security groups that detemine networking permissions of the app | `list(string)` | n/a | yes |
| subnet\_ids | Subnets in which the app will be visible | `list(string)` | n/a | yes |
| task\_role\_arn | Role used by your service to perform actions (S3, Cognito, SNS access) | `string` | n/a | yes |
| vpc\_id | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| repository\_url | n/a |

