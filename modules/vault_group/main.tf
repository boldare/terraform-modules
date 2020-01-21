data "template_file" "policy_environment_manage" {
  count = length(var.environments)

  template = file("${path.module}/policy_templates/group_kv_manage.hcl")
  vars     = {
    group_name  = var.name
    environment = var.environments[count.index].name
  }
}

resource "vault_policy" "environment_manage" {
  count = length(var.environments)

  name   = "${var.name}/${var.environments[count.index].name}/manage"
  policy = data.template_file.policy_environment_manage[count.index].rendered
}

resource "vault_identity_group" "environment_manage" {
  count = length(var.environments)

  name              = "${var.name}/${var.environments[count.index].name}/manage"
  member_entity_ids = concat(var.managers, var.environments[count.index].managers)
  policies          = [
    vault_policy.environment_manage[count.index].id,
    vault_policy.environment_read[count.index].id
  ]
}

data "template_file" "policy_environment_read" {
  count = length(var.environments)

  template = file("${path.module}/policy_templates/group_kv_read.hcl")
  vars     = {
    group_name  = var.name
    environment = var.environments[count.index].name
  }
}

resource "vault_policy" "environment_read" {
  count = length(var.environments)

  name   = "${var.name}/${var.environments[count.index].name}/read"
  policy = data.template_file.policy_environment_read[count.index].rendered
}

resource "vault_identity_group" "environment_read" {
  count = length(var.environments)

  name              = "${var.name}/${var.environments[count.index].name}/read"
  member_entity_ids = concat(var.readers, var.environments[count.index].readers)
  policies          = [vault_policy.environment_read[count.index].id]
}
