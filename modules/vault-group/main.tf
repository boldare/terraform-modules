/**
 * # Vault Group
 * This module creates a set of groups and policies that allow Entities to interact with
 * Secret Engines in secure manner.
 *
 * As a result you get a **namespace**, however it's not a namespace understood as
 * namespaces offered natively in Vault Enterprise. You will not see you resources grouped in Vault UI.
 * We agree on convention, in which you create a single "namespace" per team or service.
 *
 * ## Example
 * You have two teams: `sales` and `internal`. Each team has its own `dev` and `prod` environment. What's more, `internal` team has `local`, `staging`, `demo` and `test` environments, which could potentially complicate scaling our policies.
 * Team `sales` makes use of `kv`, `rabbitmq` and `mongodb` backends and `internal` uses `kv` only.
 * Check Terraform code in [example](./example) directory to see the implementation.
 *
 * As a result, you get the following:
 * * Vault Policies:
 *     - for paths: `/kv/sales/dev`, `/rabbitmq/sales/dev`, `/mongodb/sales/dev`:
 *        - `sales/dev-read`,
 *        - `sales/dev-read-write`
 *        - `sales/dev-write`
 *     - for paths: `/kv/sales/prod`, `/rabbitmq/sales/prod`, `/mongodb/sales/prod`:
 *        - `sales/prod-read`
 *        - `sales/prod-read-write`
 *        - `sales/prod-write`
 *     - for path `/kv/internal/dev`:
 *       - `internal/dev-read`
 *       - `internal/dev-read-write`
 *       - `internal/dev-write`
 *     - for path `/kv/internal/local`:
 *       - `internal/local-read`
 *       - `internal/local-read-write`
 *       - `internal/local-write`
 *     - for path `/kv/internal/test`:
 *       - `internal/test-read`
 *       - `internal/test-read-write`
 *       - `internal/test-write`
 *     - for path `/kv/internal/staging`:
 *       - `internal/staging-read`
 *       - `internal/staging-read-write`
 *       - `internal/staging-write`
 *     - for path `/kv/internal/demo`:
 *       - `internal/demo-read`
 *       - `internal/demo-read-write`
 *       - `internal/demo-write`
 *     - for path `/kv/internal/prod`:
 *       - `internal/prod-read`
 *       - `internal/prod-read-write`
 *       - `internal/prod-write`
 * * Vault Groups:
 *     - `sales/non-prod` with policies:
 *       - `sales/dev-read-write`
 *       - `sales/dev-write`
 *     - `sales/prod` with policies:
 *       - `sales/dev-read-write`
 *       - `sales/prod-read-write`
 *     - `internal/dev` with policies:
 *       - `internal/dev-read-write`
 *       - `internal/local-read-write`
 *       - `internal/staging-read-write`
 *       - `internal/test-read-write`
 *       - `internal/demo-read-write`
 *     - `internal/prod` with policy:
 *       - `internal/prod-read`
 * * Entities you passed to specific groups are added to these Vault Groups.
 *
 * As you can see in this complex example, you only type name of a group (aka namespace, aka prefix), environments, policies and you get a matrix of policies, groups and group attachments done for you. You don't have to worry about writing policies directly, as templates handle that for you automatically. It scales really well and helps in making configurations DRY, yet still extendable.
 *
 * Note that all entities and secrets have to be created separately as purpose of this module is to secure access
 * to secrets in a Terraform-friendly and DRY manner.
 *
 * ## Supported Secret Engines
 *
 * Most secret engines have different paths and need different permissions, so in order to support them we use `read`, `read-write` and `write` policy templates. You can inspect them in [policy-templates](./policy-templates) directory.
 *
 * * Key-Value Version 2 (name: `kv2`)
 * * Database (name: `db`)
 * * RabbitMQ (name: `rabbitmq`)
 * * AWS (name: `aws`)
 *
 */

locals {
  templates_path = "${path.module}/policy-templates"

  # Policy data contain everything needed for templates to be inflated
  policy_data = flatten([
    for environment, secret_engines in var.environments : [
      for policy in ["read", "read-write", "write"] : [
        for key, data in secret_engines : {
          type        = "${data[0]}-${policy}"
          key         = "${environment}-${key}/${policy}"
          environment = environment
          engine_path = data[1]
          separator   = var.separator
          group_name  = var.name
        }
      ]
    ]
  ])

  policy_templates = {
    for policy in local.policy_data :
    policy.key => templatefile("${local.templates_path}/${policy.type}.hcl", policy)
  }

  secret_engine_paths = {
    for environment, secret_engines in var.environments :
    environment => {
      for engine, data in secret_engines : engine => data[1]
    }
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
  policies = flatten([
    for policy in each.value.policies : [
      for env in each.value.environments : [
        for secret_engine in keys(var.environments[env]) : [
          vault_policy.policies["${env}-${secret_engine}/${policy}"].id
        ]
      ]
    ]
  ])
}
