locals {
  namespaced_api_groups = [
    "",
    "apps",
    "authorization.k8s.io",
    "autoscaling",
    "batch",
    "coordination.k8s.io",
    "events.k8s.io",
    "extensions",
    "metrics.k8s.io",
    "networking.k8s.io",
    "persistentvolumeclaims",
    "policy",
    "storage.k8s.io",
    "rbac.authorization.k8s.io",
  ]
  namespaced_resources = [
    "bindings",
    "configmaps",
    "endpoints",
    "events",
    "limitranges",
    "persistentvolumeclaims",
    "pods",
    "podtemplates",
    "replicationcontrollers",
    "resourcequotas",
    "secrets",
    "serviceaccounts",
    "services",
    "controllerrevisions",
    "daemonsets",
    "deployments",
    "replicasets",
    "statefulsets",
    "localsubjectaccessreviews",
    "horizontalpodautoscalers",
    "cronjobs",
    "jobs",
    "leases",
    "events",
    "daemonsets",
    "deployments",
    "ingresses",
    "networkpolicies",
    "replicasets",
    "pods",
    "ingresses",
    "networkpolicies",
    "poddisruptionbudgets",
    "rolebindings",
    "roles",
  ]
  secret_resources = [
    "secrets"
  ]

  administrators_default_role_rules = [
    {
      api_groups = local.namespaced_api_groups,
      resources  = local.namespaced_resources,
      verbs : ["*"],
    }
  ]

  developers_default_role_rules = [
    {
      api_groups = local.namespaced_api_groups,
      resources  = setsubtract(local.namespaced_resources, local.secret_resources)
      verbs      = ["get", "list", "watch", "describe"],
    }
  ]
}
