## Providers

| Name | Version |
|------|---------|
| template | n/a |
| vault | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| environments | Map of environments, each with specific identities that can either modify or only read defined values | <pre>map(object({<br>    managers = list(string),<br>    readers = list(string),<br>  }))</pre> | `{}` | no |
| managers | List of identities that can CRUD inside all environments | `list(string)` | `[]` | no |
| name | Name of group will be used to create a group and a corresponding KV stores | `string` | n/a | yes |
| readers | List of identities that can only read inside all environments | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| environment\_manage\_group\_ids | n/a |
| environment\_manage\_policies | n/a |
| environment\_read\_group\_ids | n/a |
| environment\_read\_policies | n/a |
| environments | n/a |

