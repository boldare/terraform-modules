locals {
  templates_path = "${path.module}/policy-templates"

  # Policy data contain everything needed for templates to be inflated
  policy_data = flatten([
    for environment, secret_engines in var.environments: [
      for policy in ["read", "write"]: [
        for key, data in secret_engines: {
          type        = "${data[0]}-${policy}"
          key         = "${environment}-${key}"
          environment = environment
          engine_path = data[1]
          separator   = var.separator
          group_name  = var.name
        }
      ]
    ]
  ])

  policy_templates = {
    for policy in local.policy_data:
      policy.key => templatefile("${local.templates_path}/${policy.type}.hcl", policy)
  }
}

resource "vault_policy" "policies" {
  for_each = local.policy_templates

  name   = "${var.name}/${each.key}"
  policy = each.value
}

resource "vault_identity_group" "groups" {
  for_each = var.groups

  name              = "${var.name}/${each.key}"
  member_entity_ids = each.value.entities
  policies          = flatten([
    for policy in each.value.policies: [
      for env in each.value.environments:
        vault_policy.policies["${env}-${policy}"].id
    ]
  ])
}
