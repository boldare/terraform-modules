data "template_file" "policy_environment_manage" {
  for_each = var.environments

  template = file("${path.module}/policy_templates/group_kv_manage.hcl")
  vars     = {
    group_name  = var.name
    environment = each.key
  }
}

resource "vault_policy" "environment_manage" {
  for_each = var.environments

  name   = "${var.name}/${each.key}/manage"
  policy = data.template_file.policy_environment_manage[each.key].rendered
}

resource "vault_identity_group" "environment_manage" {
  for_each = var.environments

  name              = "${var.name}/${each.key}/manage"
  member_entity_ids = concat(var.managers, each.value.managers)
  policies          = [
    vault_policy.environment_manage[each.key].id,
    vault_policy.environment_read[each.key].id
  ]
}

data "template_file" "policy_environment_read" {
  for_each = var.environments

  template = file("${path.module}/policy_templates/group_kv_read.hcl")
  vars     = {
    group_name  = var.name
    environment = each.key
  }
}

resource "vault_policy" "environment_read" {
  for_each = var.environments

  name   = "${var.name}/${each.key}/read"
  policy = data.template_file.policy_environment_read[each.key].rendered
}

resource "vault_identity_group" "environment_read" {
  for_each = var.environments

  name              = "${var.name}/${each.key}/read"
  member_entity_ids = concat(var.readers, each.value.readers)
  policies          = [vault_policy.environment_read[each.key].id]
}
