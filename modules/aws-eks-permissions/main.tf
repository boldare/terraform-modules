/**
 * # AWS EKS Permissions
 * Use this module to define a set of standard permissions for your EKS cluster.
 *
 * This module features the following IAM policies:
 * - Load Balancing: Allows to create and manage load balancers
 * - Autoscaling: Allows to scale existing autoscaling groups
 * - DNS: Allows to modify Route53 records in all hosted zones
 */

locals {
  prefix = title(var.name_prefix)
}

# ----------------------
# LOAD BALANCING
# ----------------------

data "aws_iam_policy_document" "load_balancing" {
  count = var.load_balancing_create ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
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

resource "aws_iam_policy" "load_balancing" {
  count = var.load_balancing_create ? 1 : 0

  name        = "${local.prefix}_EKS_LoadBalancingPolicy"
  description = "Policy that allows performing Load Balancer changes"
  policy      = data.aws_iam_policy_document.load_balancing[0].json
}

# ----------------------
# AUTOSCALING
# ----------------------

data "aws_iam_policy_document" "autoscaling" {
  count = var.autoscaling_create ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
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
  count = var.autoscaling_create ? 1 : 0

  name_prefix = "${local.prefix}_EKS_AutoscalingPolicy"
  description = "Policy that allows for autoscaling in EKS cluster"
  policy      = data.aws_iam_policy_document.autoscaling[0].json
}

# ----------------------
# DNS
# ----------------------

data "aws_iam_policy_document" "dns" {
  count = var.dns_create ? 1 : 0

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
    sid    = "HostedZones"
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "dns" {
  count = var.dns_create ? 1 : 0

  name_prefix = "${local.prefix}_EKS_DNSPolicy"
  description = "Policy that allows performing DNS changes"
  policy      = data.aws_iam_policy_document.dns[0].json
}
