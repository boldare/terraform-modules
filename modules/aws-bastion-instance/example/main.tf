data "aws_ami" "amazon_linux" {
  filter {
    name   = "name"
    values = ["Amazon Linux 2 AMI"]
  }
  owners = ["amazon"]
}

# ---------------------------------------------------------------------------------------------------------------------
# SSH AUTHORIZED KEYS
# The module creates a bucket, uploads SSH keys and synchronizes them with EC2 instances
# ---------------------------------------------------------------------------------------------------------------------

module "admin_ssh_keys" {
  source = "../../aws-s3-authorized-keys"

  bucket_name = "example-authorized-keys"
  ssh_user    = "ec2-user"
  ssh_keys    = [
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
  source = "../"

  name = "bastion-instance"

  # Machine Launch Parameters
  ssh_user             = "ec2-user"
  ami_id               = data.aws_ami.amazon_linux.id
  instance_type        = "t3.nano"
  additional_user_data = <<EOF
echo "Configuring S3 authorized_keys..."
${module.admin_ssh_keys.user_data_chunk}

EOF
  enable_monitoring    = true
  vpc_id               = var.vpc_id

  # Access
  ssh_key_name        = "example-key"
  allowed_cidr_blocks = [
    "18.202.145.21/32", # Boldare VPN IP
  ]
}
