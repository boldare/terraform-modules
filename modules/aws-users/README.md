## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_user.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_path"></a> [path](#input\_path) | You can optionally give an optional path to all users. You can use a single path, or nest multiple paths as if they were a folder structure. For example, you could use the nested path /division\_abc/subdivision\_xyz/product\_1234/engineering/ to match your company's organizational structure. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags attached to all users | `map(string)` | `{}` | no |
| <a name="input_users"></a> [users](#input\_users) | Map of users to be added to AWS IAM | <pre>map(object({<br>    email = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_user_ids"></a> [user\_ids](#output\_user\_ids) | n/a |
