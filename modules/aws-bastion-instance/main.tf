/**
 * # AWS Bastion Instance
 * This module creates Auto-Scaling Group containing a single EC2 instance with public IP.
 * The instance can access all other instances in a VPC (Security Groups are preconfigured).
 * User Data script is parameterizable and it's output is logged to `/var/log/user-data.log` by default.
 * One can use `aws-s3-authorized-keys` module in order to be able to manage SSH keys that have access to the instance.
 */

locals {
  create_count = var.create ? 1 : 0
}

resource "aws_security_group" "bastion_host" {
  count  = local.create_count
  name   = "${var.name}-bastion-host"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-bastion-host"
  }
}

resource "aws_security_group_rule" "bastion_ssh" {
  count = local.create_count

  security_group_id = aws_security_group.bastion_host[0].id
  cidr_blocks       = var.allowed_cidr_blocks
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  type              = "ingress"
}

resource "aws_security_group_rule" "bastion_all_access_egress" {
  count = local.create_count

  security_group_id = aws_security_group.bastion_host[0].id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "egress"
}

resource "aws_security_group_rule" "sg_all_access_ingress" {
  count = var.create ? length(var.egress_security_groups) : 0

  security_group_id        = var.egress_security_groups[count.index]
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion_host[0].id
  type                     = "ingress"
}

data "template_file" "user_data" {
  count = local.create_count

  template = file("${path.module}/templates/user_data.sh")
  vars = {
    additional_user_data_script = var.additional_user_data
  }
}

data "aws_iam_policy_document" "bastion" {
  count = local.create_count

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion" {
  count = local.create_count

  name_prefix        = "${var.name}-roles-"
  assume_role_policy = data.aws_iam_policy_document.bastion[0].json
}

resource "aws_iam_instance_profile" "bastion" {
  count = local.create_count

  name_prefix = "${var.name}-"
  role        = aws_iam_role.bastion[0].id
}

data "aws_ami" "amazon_linux" {
  count = local.create_count

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners      = ["amazon"]
  most_recent = true
}


resource "aws_instance" "bastion" {
  count = local.create_count

  ami                     = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux[0].id
  instance_type           = var.instance_type
  user_data               = data.template_file.user_data[0].rendered
  disable_api_termination = var.disable_api_termination
  monitoring              = var.detailed_monitoring

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    aws_security_group.bastion_host[0].id
  ]

  root_block_device {
    volume_size = var.volume_size
  }

  iam_instance_profile = aws_iam_instance_profile.bastion[0].id
  key_name             = var.ssh_key_name

  tags = merge(var.extra_tags, {
    Name = var.name
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "bastion" {
  count = var.eip_id != null ? 0 : local.create_count

  instance = aws_instance.bastion[0].id
}

resource "aws_eip_association" "bastion" {
  count = var.eip_id != null ? local.create_count : 0

  instance_id   = aws_instance.bastion[0].id
  allocation_id = var.eip_id
}
