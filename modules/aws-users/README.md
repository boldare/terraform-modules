## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.49, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.49, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| path | You can optionally give an optional path to all users. You can use a single path, or nest multiple paths as if they were a folder structure. For example, you could use the nested path /division\_abc/subdivision\_xyz/product\_1234/engineering/ to match your company's organizational structure. | `string` | `null` | no |
| tags | Additional tags attached to all users | `map(string)` | `{}` | no |
| users | Map of users to be added to AWS IAM | <pre>map(object({<br>    email = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| user\_ids | n/a |

