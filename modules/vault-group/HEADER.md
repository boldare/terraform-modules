# Vault Group
This module creates a set of groups and policies that allow Entities to interact with
Secret Engines in secure manner.

As a result you get a **namespace**, however it's not a namespace understood as
namespaces offered natively in Vault Enterprise. You will not see you resources grouped in Vault UI.
We agree on convention, in which you create a single "namespace" per team or service.

## Example
You have two teams: `sales` and `internal`. Each team has its own `dev` and `prod` environment. What's more, `internal` team has `local`, `staging`, `demo` and `test` environments, which could potentially complicate scaling our policies.
Team `sales` makes use of `kv`, `rabbitmq` and `mongodb` backends and `internal` uses `kv` only.
Check Terraform code in [example](./example) directory to see the implementation.

As a result, you get the following:
* Vault Policies:
    - `sales/dev-read` (can read secrets in paths: `/kv/sales/dev`, `/rabbitmq/sales/dev`, `/mongodb/sales/dev`)
    - `sales/dev-write` (can write secrets in paths: `/kv/sales/dev`, `/rabbitmq/sales/dev`, `/mongodb/sales/dev`)
    - `sales/prod-read` (can read secrets in paths: `/kv/sales/prod`, `/rabbitmq/sales/prod`, `/mongodb/sales/prod`)
    - `sales/prod-write` (can write secrets in paths: `/kv/sales/prod`, `/rabbitmq/sales/prod`, `/mongodb/sales/prod`)
    - `internal/dev-read` (can read secrets in paths: `/kv/internal/dev`)
    - `internal/dev-write` (can write secrets in paths: `/kv/internal/dev`)
    - `internal/local-read` (can read secrets in paths: `/kv/internal/local`)
    - `internal/local-write` (can write secrets in paths: `/kv/internal/local`)
    - `internal/test-read` (can read secrets in paths: `/kv/internal/test`)
    - `internal/test-write` (can write secrets in paths: `/kv/internal/test`)
    - `internal/staging-read` (can read secrets in paths: `/kv/internal/staging`)
    - `internal/staging-write` (can write secrets in paths: `/kv/internal/staging`)
    - `internal/demo-read` (can read secrets in paths: `/kv/internal/demo`)
    - `internal/demo-write` (can write secrets in paths: `/kv/internal/demo`)
    - `internal/prod-read` (can read secrets in paths: `/kv/internal/prod`)
    - `internal/prod-read` (can write secrets in paths: `/kv/internal/prod`)
* Vault Groups:
    - `sales/non-prod` (with policies: `sales/dev-read`, `sales/dev-write`)
    - `sales/prod` (with policies: `sales/dev-read`, `sales/dev-write`, `sales/prod-read`, `sales/prod-write`)
    - `internal/dev` (with policies: `internal/dev-read`, `internal/dev-write`, `internal/local-read`, `internal/local-write`, `internal/staging-read`, `internal/staging-write`, `internal/test-read`, `internal/test-write`, `internal/demo-read`, `internal/demo-write`)
    - `internal/prod` (with policy: `internal/prod-read`)
* Entities you passed to specific groups are added to these Vault Groups.

As you can see in this complex example, you only type name of a group (aka namespace, aka prefix), environments, policies and you get a matrix of policies, groups and group attachments done for you. You don't have to worry about writing policies directly, as templates handle that for you automatically. It scales really well and helps in making configurations DRY, yet still extendable.

Note that all entities and secrets have to be created separately as purpose of this module is to secure access
to secrets in a Terraform-friendly and DRY manner.

## Supported Secret Engines

Most secret engines have different paths and need different permissions, so in order to support them we use read and write policy templates. You can inspect them in [policy-templates](./policy-templates) directory.

* Key-Value Version 2 (name: `kv2`)
* Database (name: `db`)
* RabbitMQ (name: `rabbitmq`)
