provider "aws" {
  version = "~>2.0"
  region  = "us-east-1"
}

data "aws_ami" "amazon_linux" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners      = ["amazon"]
  most_recent = true
}

# ---------------------------------------------------------------------------------------------------------------------
# SSH AUTHORIZED KEYS
# The module creates a bucket, uploads SSH keys and synchronizes them with EC2 instances
# ---------------------------------------------------------------------------------------------------------------------

module "admin_ssh_keys" {
  source = "../../../aws-s3-authorized-keys"

  bucket_name = "example-authorized-keys"
  ssh_user    = "ec2-user"
  ssh_keys = [
    {
      name       = "krzysztof.miemiec"
      public_key = "..."
    }
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# BASTION HOST
# Instance which can be used to access the cluster instances, which are located in private subnet.
# Just SSH into bastion host first, and then SSH into the instances from within bastion host.
# ---------------------------------------------------------------------------------------------------------------------

module "bastion" {
  source = "../.."

  name = "bastion-instance"

  # Machine Launch Parameters
  instance_type           = "t3.nano"
  additional_user_data    = <<EOF
echo "Configuring S3 authorized_keys..."
${module.admin_ssh_keys.user_data_chunk}

EOF
  subnet_id               = var.subnet_id
  vpc_id                  = var.vpc_id
  disable_api_termination = true

  # Access
  ssh_key_name = "example-key"
  allowed_cidr_blocks = [
    "18.202.145.21/32", # Boldare VPN IP
  ]
}

resource "aws_iam_role_policy_attachment" "bastion_ssh_policy" {
  policy_arn = module.admin_ssh_keys.keys_s3_read_only_policy_arn
  role       = module.bastion.bastion_iam_role
}
