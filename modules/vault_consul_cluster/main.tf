# Sources
# github.com/hashicorp/terraform-aws-vault  - v0.13.3
# github.com/hashicorp/terraform-aws-consul - v0.7.3

resource "random_id" "consul_encrypt" {
  byte_length = 32
}

locals {
  vault_s3_backend_name = "${var.vault_cluster_name}-s3-backend"
  consul_gossip_key     = random_id.consul_encrypt.b64_std
}

module "vault_cluster" {
  source = "github.com/hashicorp/terraform-aws-vault//modules/vault-cluster?ref=v0.13.3"

  cluster_name  = var.vault_cluster_name
  cluster_size  = var.vault_cluster_size
  instance_type = var.vault_instance_type

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_vault_cluster.rendered

  vpc_id     = var.vpc_id
  subnet_ids = data.aws_subnet_ids.private.ids

  # Do NOT use the ELB for the ASG health check, or the ASG will assume all sealed instances are unhealthy and
  # repeatedly try to redeploy them.
  health_check_type = "EC2"

  # To make testing easier, we allow requests from any IP address here but in a production deployment, we *strongly*
  # recommend you limit this to the IP address ranges of known, trusted servers inside your VPC.

  allowed_ssh_security_group_ids       = var.ssh_security_group_ids
  allowed_inbound_cidr_blocks          = ["0.0.0.0/0"]
  allowed_inbound_security_group_ids   = []
  allowed_inbound_security_group_count = 0
  ssh_key_name                         = var.ssh_key_name

  cluster_extra_tags = [{
    key: "vault_s3_bucket_backend",
    value: aws_s3_bucket.vault_storage.id,
    propagate_at_launch: true
  }]
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH IAM POLICIES FOR CONSUL
# To allow our Vault servers to automatically discover the Consul servers, we need to give them the IAM permissions from
# the Consul AWS Module's consul-iam-policies module.
# ---------------------------------------------------------------------------------------------------------------------

module "consul_iam_policies_servers" {
  source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-iam-policies?ref=v0.7.3"

  iam_role_id = module.vault_cluster.iam_role_id
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH IAM POLICIES FOR VAULT
# To allow our Vault servers to access S3 bucket with TLS certificates
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "vault_cert_s3_access" {
  statement {
    effect    = "Allow"
    actions   = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.cert_s3_bucket_name}"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "s3:HeadObject",
      "s3:GetObject",
      "s3:GetObjectAcl"
    ]
    resources = ["arn:aws:s3:::${var.cert_s3_bucket_name}/*"]
  }
}

resource "aws_iam_policy" "vault_cert_s3_access" {
  name_prefix = "${var.vault_cluster_name}-cert-s3-access-policy"
  policy      = data.aws_iam_policy_document.vault_cert_s3_access.json
}

resource "aws_iam_role_policy_attachment" "vault_cert_s3_access" {
  policy_arn = aws_iam_policy.vault_cert_s3_access.arn
  role       = module.vault_cluster.iam_role_id
}

# ---------------------------------------------------------------------------------------------------------------------
# THE USER DATA SCRIPT THAT WILL RUN ON EACH VAULT SERVER WHEN IT'S BOOTING
# This script will configure and start Vault
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "user_data_vault_cluster" {
  template = file("${path.module}/user-data-vault.sh")

  vars = {
    additional_user_data         = var.vault_additional_user_data
    aws_region                   = var.aws_region
    consul_cluster_tag_key       = var.consul_cluster_tag_key
    consul_cluster_tag_value     = var.consul_cluster_name
    consul_gossip_key            = local.consul_gossip_key
    vault_domain_name            = var.vault_domain_name
    cert_s3_bucket_name          = var.cert_s3_bucket_name
    cert_s3_bucket_tls_cert_file = var.cert_s3_bucket_tls_cert_file
    cert_s3_bucket_tls_key_file  = var.cert_s3_bucket_tls_key_file
    cert_refresh_cron            = var.cert_refresh_cron
    s3_backend_bucket            = local.vault_s3_backend_name
    kms_key_id                   = module.kms_s3_key.kms_key_id
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 SECRET STORAGE BUCKET
# ---------------------------------------------------------------------------------------------------------------------

module "kms_s3_key" {
  source = "../kms_key"

  alias_name  = local.vault_s3_backend_name
  description = "Vault Encryption Key"

  key_admin_arns = var.s3_backend_admin_arns
  key_user_arns  = [
    module.vault_cluster.iam_role_arn
  ]
}

resource "aws_iam_role_policy_attachment" "vault_kms_user" {
  policy_arn = module.kms_s3_key.iam_user_policy_arn
  role       = module.vault_cluster.iam_role_id
}

data "aws_iam_policy_document" "vault_storage" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.vault_storage.arn]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "s3:HeadObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${aws_s3_bucket.vault_storage.arn}/*"]
  }
}

resource "aws_iam_role_policy" "vault_storage" {
  name   = "s3-backend-access"
  policy = data.aws_iam_policy_document.vault_storage.json
  role   = module.vault_cluster.iam_role_id
}

resource "aws_s3_bucket" "vault_storage" {
  bucket = local.vault_s3_backend_name
  tags   = {
    "Description" = "Used for secret storage with Vault. DO NOT DELETE this Bucket unless you know what you are doing."
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.kms_s3_key.kms_key_id
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "vault_storage" {
  bucket = aws_s3_bucket.vault_storage.bucket

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# ---------------------------------------------------------------------------------------------------------------------
# PERMIT CONSUL SPECIFIC TRAFFIC IN VAULT CLUSTER
# To allow our Vault servers consul agents to communicate with other consul agents and participate in the LAN gossip,
# we open up the consul specific protocols and ports for consul traffic
# ---------------------------------------------------------------------------------------------------------------------

module "security_group_rules" {
  source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-client-security-group-rules?ref=v0.7.3"

  security_group_id = module.vault_cluster.security_group_id

  allowed_inbound_security_group_ids   = var.ssh_security_group_ids
  allowed_inbound_security_group_count = length(var.ssh_security_group_ids)
  allowed_inbound_cidr_blocks          = []
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE ELB
# ---------------------------------------------------------------------------------------------------------------------

module "vault_elb" {
  source = "github.com/hashicorp/terraform-aws-vault//modules/vault-elb?ref=v0.13.3"

  name = var.vault_cluster_name

  vpc_id     = var.vpc_id
  subnet_ids = data.aws_subnet_ids.public.ids

  # Associate the ELB with the instances created by the Vault Autoscaling group
  vault_asg_name = module.vault_cluster.asg_name

  # To make testing easier, we allow requests from any IP address here but in a production deployment, we *strongly*
  # recommend you limit this to the IP address ranges of known, trusted servers inside your VPC.
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]

  # In order to access Vault over HTTPS, we need a domain name that matches the TLS cert
  create_dns_entry = var.create_dns_entry

  hosted_zone_id = var.hosted_zone_id

  domain_name = var.vault_domain_name
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CONSUL SERVER CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "consul_cluster" {
  source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-cluster?ref=v0.7.3"

  cluster_name  = var.consul_cluster_name
  cluster_size  = var.consul_cluster_size
  instance_type = var.consul_instance_type

  # The EC2 Instances will use these tags to automatically discover each other and form a cluster
  cluster_tag_key   = var.consul_cluster_tag_key
  cluster_tag_value = var.consul_cluster_name

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_consul.rendered

  vpc_id     = var.vpc_id
  subnet_ids = data.aws_subnet_ids.private.ids

  allowed_ssh_security_group_ids   = var.ssh_security_group_ids
  allowed_ssh_security_group_count = length(var.ssh_security_group_ids)
  allowed_inbound_cidr_blocks      = ["0.0.0.0/0"]
  ssh_key_name                     = var.ssh_key_name
}

# ---------------------------------------------------------------------------------------------------------------------
# THE USER DATA SCRIPT THAT WILL RUN ON EACH CONSUL SERVER WHEN IT'S BOOTING
# This script will configure and start Consul
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "user_data_consul" {
  template = file("${path.module}/user-data-consul.sh")

  vars = {
    additional_user_data     = var.consul_additional_user_data
    consul_cluster_tag_key   = var.consul_cluster_tag_key
    consul_cluster_tag_value = var.consul_cluster_name
    consul_gossip_key        = local.consul_gossip_key
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CLUSTERS IN THE DEFAULT VPC AND AVAILABILITY ZONES
# Using the default VPC and subnets makes this example easy to run and test, but it means Consul and Vault are
# accessible from the public Internet. In a production deployment, we strongly recommend deploying into a custom VPC
# and private subnets. Only the ELB should run in the public subnets.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
  tags   = {
    Subnet = "private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id
  tags   = {
    Subnet = "public"
  }
}
