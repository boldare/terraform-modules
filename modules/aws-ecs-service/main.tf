# ----------------------------------------------------------------------------------------------------------------------
# ECR
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_ecr_repository" "app" {
  name                 = var.repository_name
  image_tag_mutability = "IMMUTABLE"
}

# ----------------------------------------------------------------------------------------------------------------------
# LOGS
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/${var.name}"
  retention_in_days = 30

  tags = {
    Name = var.name
  }
}

resource "aws_cloudwatch_log_stream" "logs" {
  name           = var.name
  log_group_name = aws_cloudwatch_log_group.logs.name
}

resource "aws_ecr_lifecycle_policy" "app" {
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 50 images"
        selection    = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 50
        }
        action       = {
          type = "expire"
        }
      }
    ]
  })
  repository = aws_ecr_repository.app.id
}

# ----------------------------------------------------------------------------------------------------------------------
# ECS
# ----------------------------------------------------------------------------------------------------------------------

data "null_data_source" "secrets" {
  count = length(keys(var.secrets))

  inputs = {
    name      = keys(var.secrets)[count.index]
    valueFrom = values(var.secrets)[count.index]
  }
}

data "null_data_source" "environment" {
  count = length(keys(var.environment))

  inputs = {
    name  = keys(var.environment)[count.index]
    value = values(var.environment)[count.index]
  }
}

data "null_data_source" "port_mappings" {
  count = length(keys(var.port_mappings))

  inputs = {
    port     = keys(var.port_mappings)[count.index]
    protocol = values(var.port_mappings)[count.index]
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = jsonencode([{
    name             = var.name
    essential        = true
    image            = length(var.image_tag)>0 ? "${aws_ecr_repository.app.repository_url}:${var.image_tag}" : "busybox:latest"
    cpu              = var.fargate_cpu
    memory           = var.fargate_memory
    networkMode      = "awsvpc"
    secrets          = data.null_data_source.secrets.*.outputs
    environment      = data.null_data_source.environment.*.outputs
    portMappings     = [
    for value in data.null_data_source.port_mappings.*.outputs:
    {
      hostPort      = tonumber(value.port)
      containerPort = tonumber(value.port)
      protocol      = value.protocol
    }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options   = {
        awslogs-group         = aws_cloudwatch_log_group.logs.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])

}

resource "aws_ecs_service" "this" {
  name            = "${var.name}-service"
  cluster         = var.ecs_cluster
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.instance_count
  launch_type     = "FARGATE"

  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  deployment_minimum_healthy_percent = 50

  network_configuration {
    security_groups  = var.sg_ids
    subnets          = var.subnet_ids
    assign_public_ip = false
  }

  dynamic "load_balancer" {
    for_each = var.exposed_ports
    content {
      target_group_arn = aws_lb_target_group.target_groups[load_balancer.key].arn
      container_name   = var.name
      container_port   = load_balancer.key
    }
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# LOAD BALANCER
# ----------------------------------------------------------------------------------------------------------------------

resource "random_pet" "lb_target_groups" {
  for_each = var.exposed_ports

  prefix  = "${var.name}-${each.key}"
  keepers = {
    vpc_id = var.vpc_id
    key    = each.key
    value  = jsonencode(each.value)
  }
}

resource "aws_lb_target_group" "target_groups" {
  for_each = var.exposed_ports

  name        = substr(random_pet.lb_target_groups[each.key].id, 0, 32)
  port        = tonumber(each.key)
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = each.value.health_check != null
    healthy_threshold   = each.value.health_check != null ? each.value.health_check.threshold : null
    unhealthy_threshold = each.value.health_check != null ? each.value.health_check.threshold : null
    interval            = each.value.health_check != null ? each.value.health_check.interval : null
    protocol            = each.value.health_check != null ? each.value.health_check.protocol : null
    path                = each.value.health_check != null ? each.value.health_check.path : null
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
}

# Redirect all traffic from the LB to the target group
resource "aws_lb_listener" "listener" {
  for_each = var.exposed_ports

  load_balancer_arn = var.load_balancer_arn
  port              = tonumber(each.value.expose_as)
  protocol          = each.value.protocol

  default_action {
    target_group_arn = aws_lb_target_group.target_groups[each.key].id
    type             = "forward"
  }
}
