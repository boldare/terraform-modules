# Vault Group  
This module creates a set of groups and policies that allow Entities to interact with  
Secret Engines in secure manner.

As a result you get a \*\*namespace\*\*, however it's not a namespace understood as  
namespaces offered natively in Vault Enterprise. You will not see you resources grouped in Vault UI.  
We agree on convention, in which you create a single "namespace" per team or service.

## Example  
You have two teams: `sales` and `internal`. Each team has its own `dev` and `prod` environment. What's more, `internal` team has `local`, `staging`, `demo` and `test` environments, which could potentially complicate scaling our policies.  
Team `sales` makes use of `kv`, `rabbitmq` and `mongodb` backends and `internal` uses `kv` only.  
Check Terraform code in [example](./example) directory to see the implementation.

As a result, you get the following:
* Vault Policies:
    - for paths: `/kv/sales/dev`, `/rabbitmq/sales/dev`, `/mongodb/sales/dev`:
       - `sales/dev-read`,
       - `sales/dev-read-write`
       - `sales/dev-write`
    - for paths: `/kv/sales/prod`, `/rabbitmq/sales/prod`, `/mongodb/sales/prod`:
       - `sales/prod-read`
       - `sales/prod-read-write`
       - `sales/prod-write`
    - for path `/kv/internal/dev`:
      - `internal/dev-read`
      - `internal/dev-read-write`
      - `internal/dev-write`
    - for path `/kv/internal/local`:
      - `internal/local-read`
      - `internal/local-read-write`
      - `internal/local-write`
    - for path `/kv/internal/test`:
      - `internal/test-read`
      - `internal/test-read-write`
      - `internal/test-write`
    - for path `/kv/internal/staging`:
      - `internal/staging-read`
      - `internal/staging-read-write`
      - `internal/staging-write`
    - for path `/kv/internal/demo`:
      - `internal/demo-read`
      - `internal/demo-read-write`
      - `internal/demo-write`
    - for path `/kv/internal/prod`:
      - `internal/prod-read`
      - `internal/prod-read-write`
      - `internal/prod-write`
* Vault Groups:
    - `sales/non-prod` with policies:
      - `sales/dev-read-write`
      - `sales/dev-write`
    - `sales/prod` with policies:
      - `sales/dev-read-write`
      - `sales/prod-read-write`
    - `internal/dev` with policies:
      - `internal/dev-read-write`
      - `internal/local-read-write`
      - `internal/staging-read-write`
      - `internal/test-read-write`
      - `internal/demo-read-write`
    - `internal/prod` with policy:
      - `internal/prod-read`
* Entities you passed to specific groups are added to these Vault Groups.

As you can see in this complex example, you only type name of a group (aka namespace, aka prefix), environments, policies and you get a matrix of policies, groups and group attachments done for you. You don't have to worry about writing policies directly, as templates handle that for you automatically. It scales really well and helps in making configurations DRY, yet still extendable.

Note that all entities and secrets have to be created separately as purpose of this module is to secure access  
to secrets in a Terraform-friendly and DRY manner.

## Supported Secret Engines

Most secret engines have different paths and need different permissions, so in order to support them we use `read`, `read-write` and `write` policy templates. You can inspect them in [policy-templates](./policy-templates) directory.

* Key-Value Version 2 (name: `kv2`)
* Database (name: `db`)
* RabbitMQ (name: `rabbitmq`)
* AWS (name: `aws`)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| vault | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environments | This maps environment names to objects containing definitions of secret engines used by those environments. For example, your `dev` environment may use `{ rabbitmq = ["rabbitmq", "/rabbitmq/non-prod"] }` and your `prod` can equal to `{ rabbitmq = ["rabbitmq", "/rabbitmq/prod"] }`. | `map(map(list(string)))` | `{}` | no |
| groups | Groups map entity ids (users/apps) to permissions. Policies can contain "read" and/or "write". | <pre>map(object({<br>    entities     = list(string)<br>    policies     = list(string)<br>    environments = list(string)<br>  }))</pre> | `{}` | no |
| name | Name of group will be used to create a group and a corresponding KV stores | `string` | n/a | yes |
| separator | Separator used in places, where regular path nesting is not possible. While in KV you can do `/kv/group/env/key`, in RabbitMQ it has to be non-slash character: `/rabbitmq/group-env-key`. | `string` | `"-"` | no |

## Outputs

| Name | Description |
|------|-------------|
| environments | Environments variable passthrough. |
| group\_ids | Map containing all groups mapped to their IDs in Vault. |
| group\_policies | Map containing group names mapped to list of policies of each group. |
| groups | All Vault groups created by this module. |
| policies | All Vault policies created by this module. |
| policy\_ids | Map containing all policies mapped to their IDs in Vault. |
| secret\_engine\_paths | Environments variable, but without Secret Engine types. For example kv = ["kv2", "kv"] becomes just kv = "kv" |

