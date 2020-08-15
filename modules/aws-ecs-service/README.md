# AWS ECS Service  
Creates ECS service with cloudwatch, ECR repository, task definition, load balancer and autoscaler.  
Its highly recommended to use `aws-ecs-service-permissions` with this module to create all necessary roles and policies.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.49, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.49, < 4.0 |
| null | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region things are created in | `string` | n/a | yes |
| az\_count | Number of Availability Zones to cover in a given region | `number` | `2` | no |
| cluster\_name | Name of the cluster | `string` | n/a | yes |
| ecs\_cluster | ECS cluster to run ECS Service in | `string` | n/a | yes |
| enable\_http\_to\_https\_redirect | Enables HTTP forwarding to HTTPS | `bool` | `false` | no |
| environment | Environment Variables for the container | `map(string)` | `{}` | no |
| execution\_role\_arn | Role used by the Fargate to perform actions (Docker pull, logs) | `string` | n/a | yes |
| exposed\_ports | n/a | <pre>map(object({<br>    expose_as       = number<br>    protocol        = string<br>    protocol_lb     = string<br>    ssl_policy      = string<br>    certificate_arn = string<br>    health_check    = any<br>  }))</pre> | n/a | yes |
| fargate\_cpu | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `number` | `512` | no |
| fargate\_memory | Fargate instance memory to provision (in MiB) | `number` | `1024` | no |
| health\_check\_grace\_period\_seconds | Grace period before health check checks if container is running | `number` | `15` | no |
| health\_check\_path | AWS will perform GET requests on this path to determine if service is running | `string` | `"/"` | no |
| image\_tag | ECR image tag to use; if not present, we use `:latest` | `string` | `null` | no |
| instance\_count | Number of docker containers to run | `number` | `3` | no |
| internal\_port | Port inside container that service is on | `number` | n/a | yes |
| load\_balancer\_arn | ARN of LoadBalanser used to access service | `string` | n/a | yes |
| name | Name of the app used in ECS | `string` | n/a | yes |
| port | Port that containers service is available from outside | `number` | n/a | yes |
| port\_mappings | n/a | `map(string)` | n/a | yes |
| repository\_name | ECR repository name | `string` | n/a | yes |
| scaling\_max\_capacity | Max amount of containers to scale in | `number` | `4` | no |
| scaling\_min\_capacity | Min amount of containers to scale in | `number` | `1` | no |
| secrets | AWS Secrets Manager secrets to insert as variables for the container | `map(string)` | `{}` | no |
| sg\_ids | Security groups that determine networking permissions of the app | `list(string)` | n/a | yes |
| subnet\_ids | Subnets in which the app will be visible | `list(string)` | n/a | yes |
| task\_role\_arn | Role used by your service to perform actions (S3, Cognito, SNS access) | `string` | n/a | yes |
| vpc\_id | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| repository\_url | n/a |

