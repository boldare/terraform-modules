# AWS ECS Service
Creates ECS service with cloudwatch, ECR repository, task definition, load balancer and autoscaler.
Its highly recommended to use `aws-ecs-service-permissions` with this module to create all necessary roles and policies.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0, < 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ecr_lifecycle_policy.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.redirect_http_to_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [random_pet.lb_target_groups](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region things are created in | `string` | n/a | yes |
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Number of Availability Zones to cover in a given region | `number` | `2` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster) | ECS cluster to run ECS Service in | `string` | n/a | yes |
| <a name="input_enable_http_to_https_redirect"></a> [enable\_http\_to\_https\_redirect](#input\_enable\_http\_to\_https\_redirect) | Enables HTTP forwarding to HTTPS | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variables for the container | `map(string)` | `{}` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | Role used by the Fargate to perform actions (Docker pull, logs) | `string` | n/a | yes |
| <a name="input_exposed_ports"></a> [exposed\_ports](#input\_exposed\_ports) | n/a | <pre>map(object({<br>    expose_as       = number<br>    protocol        = string<br>    protocol_lb     = string<br>    ssl_policy      = string<br>    certificate_arn = string<br>    health_check    = any<br>  }))</pre> | n/a | yes |
| <a name="input_fargate_cpu"></a> [fargate\_cpu](#input\_fargate\_cpu) | Fargate instance CPU units to provision (1 vCPU = 1024 CPU units) | `number` | `512` | no |
| <a name="input_fargate_memory"></a> [fargate\_memory](#input\_fargate\_memory) | Fargate instance memory to provision (in MiB) | `number` | `1024` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Grace period before health check checks if container is running | `number` | `15` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | AWS will perform GET requests on this path to determine if service is running | `string` | `"/"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | ECR image tag to use; if not present, we use `:latest` | `string` | `null` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of docker containers to run | `number` | `3` | no |
| <a name="input_internal_port"></a> [internal\_port](#input\_internal\_port) | Port inside container that service is on | `number` | n/a | yes |
| <a name="input_load_balancer_arn"></a> [load\_balancer\_arn](#input\_load\_balancer\_arn) | ARN of LoadBalanser used to access service | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the app used in ECS | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | Port that containers service is available from outside | `number` | n/a | yes |
| <a name="input_port_mappings"></a> [port\_mappings](#input\_port\_mappings) | n/a | `map(string)` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | ECR repository name | `string` | n/a | yes |
| <a name="input_scaling_max_capacity"></a> [scaling\_max\_capacity](#input\_scaling\_max\_capacity) | Max amount of containers to scale in | `number` | `4` | no |
| <a name="input_scaling_min_capacity"></a> [scaling\_min\_capacity](#input\_scaling\_min\_capacity) | Min amount of containers to scale in | `number` | `1` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | AWS Secrets Manager secrets to insert as variables for the container | `map(string)` | `{}` | no |
| <a name="input_sg_ids"></a> [sg\_ids](#input\_sg\_ids) | Security groups that determine networking permissions of the app | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnets in which the app will be visible | `list(string)` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | Role used by your service to perform actions (S3, Cognito, SNS access) | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | n/a |
