/**
 * # AWS Bastion Instance
 * This module creates Auto-Scaling Group containing a single EC2 instance with public IP.
 * The instance can access all other instances in a VPC (Security Groups are preconfigured).
 * User Data script is parametrizable and it's output is logged to `/var/log/user-data.log` by default.
 * One can use `aws-s3-authorized-keys` module in order to be able to manage SSH keys that have access to the instance.
 */

data "aws_subnet_ids" "vpc" {
  vpc_id = var.vpc_id
  tags   = var.vpc_public_subnet_tags
}

resource "aws_security_group" "bastion_host" {
  name   = "${var.name}-bastion-host"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-bastion-host"
  }
}

resource "aws_security_group_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion_host.id
  cidr_blocks       = var.allowed_cidr_blocks
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_all_access_egress" {
  security_group_id = aws_security_group.bastion_host.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "egress"
}

resource "aws_security_group_rule" "sg_all_access_ingress" {
  count = length(var.egress_security_groups)

  security_group_id        = var.egress_security_groups[count.index]
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion_host.id
  type                     = "ingress"
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")
  vars     = {
    additional_user_data_script = var.additional_user_data
  }
}

data "aws_iam_policy_document" "bastion" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion" {
  name_prefix        = "${var.name}-roles-"
  assume_role_policy = data.aws_iam_policy_document.bastion.json
}

resource "aws_iam_instance_profile" "bastion" {
  name_prefix = "${var.name}-"
  role        = aws_iam_role.bastion.id
}

resource "aws_launch_configuration" "bastion" {
  name_prefix                 = "${var.name}-"
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  user_data                   = data.template_file.user_data.rendered
  enable_monitoring           = var.enable_monitoring
  associate_public_ip_address = true

  security_groups = [
    aws_security_group.bastion_host.id
  ]

  root_block_device {
    volume_size = var.volume_size
  }

  iam_instance_profile = aws_iam_instance_profile.bastion.id
  key_name             = var.ssh_key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name = aws_launch_configuration.bastion.name

  vpc_zone_identifier = data.aws_subnet_ids.vpc.ids

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.bastion.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tags = concat(
  [
    {
      key                 = "Name",
      value               = var.name,
      propagate_at_launch = true
    }
  ],
  var.extra_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}
