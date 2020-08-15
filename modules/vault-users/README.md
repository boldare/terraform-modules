# Vault Users  
This module creates entities in Vault that are automatically connected to aliases for specified auth backend.  
You can use it to create list of users that can log in to Vault using OpenID Connect, i.e. via Google or GitLab.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| vault | >= 2.0, < 3.0 |

## Providers

| Name | Version |
|------|---------|
| vault | >= 2.0, < 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auth\_backend\_accessor | Auth backend accessor used for authentication. For example, Google OIDC aliases are created. | `string` | n/a | yes |
| users | Map of users to create or include in Vault. Map user name to email. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| ids | User names mapped to their identifiers in Vault. |
| users | User names mapped to their emails (same as 'users' input variable). |

