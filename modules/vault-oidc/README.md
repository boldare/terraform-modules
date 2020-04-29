# Vault OIDC  
This module creates Vault JWT Auth Backend, which allows you to log in to Vault  
using well-known services you already use.

For instance, you may configure this module to let you in to vault after  
authorizing via GitLab or Google account.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| vault | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_id | OpenID client identifier. It should be generated on target service. | `string` | n/a | yes |
| client\_secret | OpenID client secret. It should be generated on target service. | `string` | n/a | yes |
| default\_token\_policies | Default policy for everyone that's authorized using this method. I.e. this policies may allow access to cubbyhole and utilities. | `list(string)` | n/a | yes |
| description | Description of this auth method. You should write something that provides more than just a name here. | `string` | `"OpenID Connect auth method."` | no |
| domain | Domain used to authenticate (i.e. gitlab.com) | `string` | n/a | yes |
| path | Path to place this auth method. It can be just 'gitlab' for GitLab. | `string` | `"oidc"` | no |
| role\_name | Role name for this OIDC Auth | `string` | n/a | yes |
| scopes | This is a list of scopes/permissions you will be asked to provide during login via target service. | `list(string)` | <pre>[<br>  "profile",<br>  "email"<br>]</pre> | no |
| ttl | Time-To-Live (in seconds) for Vault tokens genereated by this method. It should be set to a time comfortable for all users, yet still short enough to be safe in case of breach. | `number` | `43200` | no |
| vault\_domain | Domain for your Vault installation. This is used to redirect you back to Vault from external service after authentication. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| accessor | n/a |
| redirect\_uris | n/a |

