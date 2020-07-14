/**
 * # AWS EKS Namespace
 * Use this module to quickly bootstrap an environment for project running on EKS cluster.
 *
 * This module creates:
 * - a Kubernetes namespace
 * - IAM user groups (for administrators and developers)
 * - optional CI role
 * - bindings between IAM roles and Kubernetes RBAC roles
 * - set of ECR, S3 and EKS permissions for IAM roles
 * - set of RBAC permissions for RBAC roles
 */

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

locals {
  namespace_name = kubernetes_namespace.namespace.metadata[0].name
}


module "aws_namespace" {
  source         = "./aws"
  namespace_name = local.namespace_name
}

# ----------------------------------------------------------------------------------------------------------------------
# ADMINISTRATORS
# Binding between Kubernetes roles and AWS IAM, specific for administrators.
# Allows access to Kubernetes cluster (do-all within a namespace), ECR repository and S3 buckets (scoped for namespace)
# ----------------------------------------------------------------------------------------------------------------------

locals {
  administrators_default_policies = {
    cluster = module.aws_namespace.cluster_policy_arn
    ecr     = module.aws_namespace.ecr_policy_arn
    s3      = module.aws_namespace.s3_policy_arn
  }
  administrators_iam_policies = merge(local.administrators_default_policies, var.administrators_iam_policies)
  administrators_group_users  = concat(var.create_ci_iam_user ? [aws_iam_user.ci[0].name] : [], var.administrators)
  admin_role_rules = concat(
    var.admin_kubernetes_role_rules == null ? local.administrators_default_role_rules : var.admin_kubernetes_role_rules,
    var.admin_kubernetes_role_rules_extra
  )
}

module "administrators" {
  source = "../aws-eks-iam-role-group"

  iam_role     = "${local.namespace_name}-admin"
  iam_path     = var.iam_path
  iam_group    = "${local.namespace_name}-administrators"
  iam_policies = local.administrators_iam_policies
  # CI User deploys all resources to the namespace, so it also belongs to the admin group
  iam_group_users            = zipmap(local.administrators_group_users, local.administrators_group_users)
  additional_role_principals = var.additional_admin_role_principals

  kubernetes_role       = "${local.namespace_name}-admin"
  kubernetes_namespace  = local.namespace_name
  kubernetes_role_rules = local.admin_role_rules
}

# ----------------------------------------------------------------------------------------------------------------------
# DEVELOPERS
# ----------------------------------------------------------------------------------------------------------------------

locals {
  developers_default_policies = {
    cluster = module.aws_namespace.cluster_policy_arn
    ecr     = module.aws_namespace.ecr_read_policy_arn
    s3      = module.aws_namespace.s3_read_policy_arn
  }
  developers_iam_policies = merge(local.developers_default_policies, var.developers_iam_policies)
  developers_role_rules = concat(
    var.developer_kubernetes_role_rules == null ? local.developers_default_role_rules : var.developer_kubernetes_role_rules,
    var.developer_kubernetes_role_rules_extra
  )
}

module "developers" {
  source = "../aws-eks-iam-role-group"

  iam_role     = "${local.namespace_name}-developer"
  iam_path     = var.iam_path
  iam_group    = "${local.namespace_name}-developers"
  iam_policies = local.developers_iam_policies
  # CI User deploys all resources to the namespace, so it also belongs to the admin group
  iam_group_users            = zipmap(var.developers, var.developers)
  additional_role_principals = var.additional_developer_role_principals

  kubernetes_role       = "${local.namespace_name}-developer"
  kubernetes_namespace  = local.namespace_name
  kubernetes_role_rules = local.developers_role_rules
}

# ----------------------------------------------------------------------------------------------------------------------
# CONTINUOUS INTEGRATION USER
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_iam_user" "ci" {
  count = var.create_ci_iam_user ? 1 : 0
  name  = "${local.namespace_name}-ci"
  path  = var.iam_path
}
