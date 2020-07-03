resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}
locals {
  namespace_name = kubernetes_namespace.namespace.metadata[0].name
  iam_path       = var.iam_path != null ? var.iam_path : "/${local.namespace_name}/"
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
  administrators_iam_policies = zipmap(
    concat(keys(local.administrators_default_policies), keys(var.administrators_iam_policies)),
    concat(values(local.administrators_default_policies), values(var.administrators_iam_policies))
  )
  administrators_group_users = concat([aws_iam_user.ci.name], var.administrators)
}

module "administrators" {
  source = "../aws-eks-iam-role-group"

  iam_role     = "${local.namespace_name}-admin"
  iam_path     = local.iam_path
  iam_group    = "${local.namespace_name}-administrators"
  iam_policies = local.administrators_iam_policies
  # CI User deploys all resources to the namespace, so it also belongs to the admin group
  iam_group_users            = zipmap(local.administrators_group_users, local.administrators_group_users)
  additional_role_principals = var.additional_admin_role_principals

  kubernetes_role      = "${local.namespace_name}-admin"
  kubernetes_namespace = local.namespace_name
  kubernetes_role_rules = [
    {
      api_groups : [
        "",
        "apps",
        "autoscaling",
        "extensions",
        "persistentvolumeclaims",
        "networking.k8s.io",
        "storage.k8s.io",
        "rbac.authorization.k8s.io",
        "kubedb.com"
      ],
      resources : ["*"],
      verbs : ["*"],
    },
    {
      api_groups : ["batch"],
      resources : ["jobs", "cronjobs"],
      verbs : ["*"],
    }
  ]
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
  developers_iam_policies = zipmap(
    concat(keys(local.developers_default_policies), keys(var.developers_iam_policies)),
    concat(values(local.developers_default_policies), values(var.developers_iam_policies))
  )
}

module "developers" {
  source = "../aws-eks-iam-role-group"

  iam_role     = "${local.namespace_name}-developer"
  iam_path     = local.iam_path
  iam_group    = "${local.namespace_name}-developers"
  iam_policies = local.developers_iam_policies
  # CI User deploys all resources to the namespace, so it also belongs to the admin group
  iam_group_users            = zipmap(var.developers, var.developers)
  additional_role_principals = var.additional_developer_role_principals

  kubernetes_role      = "${local.namespace_name}-developer"
  kubernetes_namespace = local.namespace_name
  kubernetes_role_rules = [
    {
      api_groups : [
        "",
        "apps",
        "autoscaling",
        "extensions",
        "persistentvolumeclaims",
        "networking.k8s.io",
        "storage.k8s.io",
        "rbac.authorization.k8s.io",
        "kubedb.com"
      ],
      resources : ["*"],
      verbs : ["get", "list", "watch"],
    },
    {
      api_groups : ["batch"],
      resources : ["jobs", "cronjobs"],
      verbs : ["get", "list", "watch", "describe"],
    }
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# CONTINUOUS INTEGRATION USER
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_iam_user" "ci" {
  name = "${local.namespace_name}-ci"
  path = local.iam_path
}
