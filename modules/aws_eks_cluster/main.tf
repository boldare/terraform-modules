locals {
  admin_username = "cluster-admin"
  admin_groups   = ["system:masters"]
  admin_roles    = [
  for arn in var.admin_iam_roles:
  {
    rolearn  = arn
    username = split("/", arn)[1]
    groups   = local.admin_groups
  }
  ]
  admin_users    = [
  for arn in var.admin_iam_users:
  {
    userarn  = arn
    username = split("/", arn)[1]
    groups   = local.admin_groups
  }
  ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>7.0.0"

  cluster_name                  = var.cluster_name
  subnets                       = var.subnets
  vpc_id                        = var.vpc_id
  cluster_version               = var.cluster_version
  worker_groups                 = var.worker_groups
  worker_groups_launch_template = var.worker_groups_launch_template
  map_roles                     = concat(var.map_roles, local.admin_roles)
  map_users                     = local.admin_users

  tags = {
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = var.cluster_name
  }

  workers_additional_policies = [
    aws_iam_policy.dns.arn,
    aws_iam_policy.alb_ingress.arn,
    aws_iam_policy.autoscaling.arn
  ]

  kubeconfig_aws_authenticator_command       = "aws"
  kubeconfig_aws_authenticator_command_args  = [
    "--region", var.region,
    "eks", "get-token",
    "--cluster-name", var.cluster_name
  ]
  kubeconfig_aws_authenticator_env_variables = {
    AWS_PROFILE = var.aws_profile
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CLUSTER IAM POLICIES
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "alb_ingress" {
  statement {
    effect    = "Allow"
    actions   = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupIngress",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL",
      "iam:CreateServiceLinkedRole",
      "iam:GetServerCertificate",
      "iam:ListServerCertificates",
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
      "tag:GetResources",
      "tag:TagResources",
      "waf:GetWebACL"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "alb_ingress" {
  name_prefix = "${var.cluster_name}-alb-ingress"
  description = "ALB Ingress Policy for ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.alb_ingress.json
}

data "aws_iam_policy_document" "autoscaling" {
  statement {
    effect    = "Allow"
    actions   = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:DescribeLaunchConfigurations",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "autoscaling" {
  name_prefix = "${var.cluster_name}-autoscaling"
  description = "Autoscaling Policy for ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.autoscaling.json
}

data "aws_iam_policy_document" "dns" {
  statement {
    sid       = "ChangeSet"
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    sid       = "GetChange"
    effect    = "Allow"
    actions   = ["route53:GetChange"]
    resources = ["arn:aws:route53:::change/*"]
  }
  statement {
    sid       = "HostedZones"
    effect    = "Allow"
    actions   = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "dns" {
  name_prefix = "${var.cluster_name}-dns"
  description = "ALB Ingress Policy for ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.dns.json
}
