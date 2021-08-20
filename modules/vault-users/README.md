# Vault Users
This module creates entities in Vault that are automatically connected to aliases for specified auth backend.
You can use it to create list of users that can log in to Vault using OpenID Connect, i.e. via Google or GitLab.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0, < 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0, < 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_identity_entity.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity) | resource |
| [vault_identity_entity_alias.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity_alias) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth_backend_accessor"></a> [auth\_backend\_accessor](#input\_auth\_backend\_accessor) | Auth backend accessor used for authentication. For example, Google OIDC aliases are created. | `string` | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | Map of users to create or include in Vault. Map user name to email. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ids"></a> [ids](#output\_ids) | User names mapped to their identifiers in Vault. |
| <a name="output_users"></a> [users](#output\_users) | User names mapped to their emails (same as 'users' input variable). |
