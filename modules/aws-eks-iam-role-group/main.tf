/**
 * # AWS EKS IAM Role Group
 * Defines AWS IAM group connected to Kubernetes Role.
 */

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------------------------------------------------
# IAM ROLES AND PERMISSIONS
# ----------------------------------------------------------------------------------------------------------------------
module "group" {
  source = "../aws-iam-user-group"

  name  = var.iam_group
  users = var.iam_group_users
  path  = var.iam_path

  attached_policy_arns = var.iam_group_policies
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_role" {
  name               = var.iam_role
  path               = var.iam_path
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "allow_assume_role_policy" {
  statement {
    sid       = "AssumeNamespaceRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.iam_role.arn]
  }
}

resource "aws_iam_role_policy_attachment" "role_policies" {
  for_each = var.iam_group_policies

  policy_arn = each.value
  role       = aws_iam_role.iam_role.id
}

resource "aws_iam_group_policy" "assume_role" {
  group  = module.group.iam_group
  name   = "${aws_iam_role.iam_role.name}-assume-policy"
  policy = data.aws_iam_policy_document.allow_assume_role_policy.json
}

# ----------------------------------------------------------------------------------------------------------------------
# KUBERNETES ROLES AND PERMISSIONS
# ----------------------------------------------------------------------------------------------------------------------

locals {
  kubernetes_namespace = var.kubernetes_namespace == null ? "" : var.kubernetes_namespace
  kubernetes_group     = "${var.kubernetes_role}-group"
  use_cluster_role     = length(local.kubernetes_namespace) == 0
}

# Cluster role for specific user
resource "kubernetes_cluster_role" "this" {
  count = local.use_cluster_role ? 1 : 0

  metadata {
    name = var.kubernetes_role
  }

  dynamic "rule" {
    for_each = var.kubernetes_role_rules
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  count = local.use_cluster_role ? 1 : 0

  metadata {
    name = "${var.kubernetes_role}-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this[0].metadata[0].name
  }

  subject {
    kind = "Group"
    name = local.kubernetes_group
  }
}

resource "kubernetes_role" "this" {
  count = local.use_cluster_role ? 0 : 1

  metadata {
    name      = var.kubernetes_role
    namespace = local.kubernetes_namespace
  }

  dynamic "rule" {
    for_each = var.kubernetes_role_rules
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_role_binding" "this" {
  count = local.use_cluster_role ? 0 : 1

  metadata {
    name      = "${var.kubernetes_role}-binding"
    namespace = local.kubernetes_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this[0].metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = local.kubernetes_group
    namespace = local.kubernetes_namespace
  }
}
