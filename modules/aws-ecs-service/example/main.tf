resource "aws_ecs_cluster" "cluster" {
  name = "boldare-cluster"
}

module "app" {
  source = "../"

  name                              = "boldare-app"
  repository_name                   = "boldare/app"
  cluster_name                      = "boldare-cluster"
  internal_port                     = 8000
  port                              = 80
  health_check_path                 = "/health"
  health_check_grace_period_seconds = 80
  task_role_arn                     = var.app_task_role_arn
  execution_role_arn                = var.app_execution_role_arn
  scaling_min_capacity              = "1"
  scaling_max_capacity              = "2"

  aws_region  = var.aws_region
  ecs_cluster = aws_ecs_cluster.cluster.id
  sg_ids = [
  var.network_workloads_sg_id]
  subnet_ids        = var.network_private_subnets
  vpc_id            = var.network_vpc_id
  load_balancer_arn = var.network_lb_arn


  port_mappings = {
    "8000" = "HTTP"
  }

  exposed_ports = {
    "8000" = {
      expose_as       = "443"
      protocol        = "HTTPS"
      protocol_lb     = "HTTP"
      ssl_policy      = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
      certificate_arn = var.api_certificate_arn
      health_check = {
        threshold = 2
        interval  = 10
        path      = "/"
        protocol  = "HTTP"
      }
    }
  }

  enable_http_to_https_redirect = true

  image_tag      = var.image_tag
  az_count       = "1"
  fargate_cpu    = "256"
  fargate_memory = "512"
  instance_count = "1"

  secrets = {
    SECRET_KEY = var.secret
  }

  environment = {
    debug = "false"
  }

}
