variable "name" {
  type        = string
  description = "Name of the app used in ECS"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "repository_name" {
  type        = string
  description = "ECR repository name"
}

variable "image_tag" {
  type        = string
  description = "ECR image tag to use; if not present, we use `:latest`"
  default     = null
}

variable "health_check_path" {
  type        = string
  description = "AWS will perform GET requests on this path to determine if service is running"
  default     = "/"
}

variable "health_check_grace_period_seconds" {
  type        = number
  default     = 15
  description = "Grace period before health check checks if container is running"
}

variable "internal_port" {
  type        = number
  description = "Port inside container that service is on"
}

variable "port" {
  type        = number
  description = "Port that containers service is available from outside"
}

variable "port_mappings" {
  type = map(string)
}

variable "exposed_ports" {
  type = map(object({
    expose_as       = number
    protocol        = string
    protocol_lb     = string
    ssl_policy      = string
    certificate_arn = string
    health_check    = any
  }))
}

variable "task_role_arn" {
  type        = string
  description = "Role used by your service to perform actions (S3, Cognito, SNS access)"
}

variable "execution_role_arn" {
  type        = string
  description = "Role used by the Fargate to perform actions (Docker pull, logs)"
}

variable "enable_http_to_https_redirect" {
  type        = bool
  default     = false
  description = "Enables HTTP forwarding to HTTPS"
}

# ----------------------------------------------------------------------------------------------------------------------
# Dependencies necessary for resource creation
# ----------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region things are created in"
}

variable "ecs_cluster" {
  type        = string
  description = "ECS cluster to run ECS Service in"
}

variable "vpc_id" {
  type = string
}

variable "sg_ids" {
  type        = list(string)
  description = "Security groups that determine networking permissions of the app"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets in which the app will be visible"
}

variable "load_balancer_arn" {
  type        = string
  description = "ARN of LoadBalanser used to access service"
}

# ----------------------------------------------------------------------------------------------------------------------
# Resources required by service (CPU, memory, number of instances/AZs)
# ----------------------------------------------------------------------------------------------------------------------

variable "az_count" {
  type        = number
  description = "Number of Availability Zones to cover in a given region"
  default     = 2
}

variable "secrets" {
  type        = map(string)
  description = "AWS Secrets Manager secrets to insert as variables for the container"
  default     = {}
}

variable "environment" {
  type        = map(string)
  description = "Environment Variables for the container"
  default     = {}
}

variable "instance_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "fargate_cpu" {
  type        = number
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 512
}

variable "fargate_memory" {
  type        = number
  description = "Fargate instance memory to provision (in MiB)"
  default     = 1024
}

variable "scaling_max_capacity" {
  type        = number
  description = "Max amount of containers to scale in"
  default     = 4
}

variable "scaling_min_capacity" {
  type        = number
  description = "Min amount of containers to scale in"
  default     = 1
}