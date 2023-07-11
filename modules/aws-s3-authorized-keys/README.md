## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0, < 5.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_s3_bucket.keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.ssh_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_public_access_block.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_iam_policy_document.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.update_ssh_authorized_keys](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.user_data_chunk](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of bucket to store SSH keys | `string` | n/a | yes |
| <a name="input_keys_update_frequency"></a> [keys\_update\_frequency](#input\_keys\_update\_frequency) | How often keys should be fetched from S3 bucket | `string` | `"0 * * * *"` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | n/a | <pre>list(object({<br>    name       = string,<br>    public_key = string<br>  }))</pre> | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | User to use to login to instance | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keys_s3_bucket"></a> [keys\_s3\_bucket](#output\_keys\_s3\_bucket) | n/a |
| <a name="output_keys_s3_read_only_policy_arn"></a> [keys\_s3\_read\_only\_policy\_arn](#output\_keys\_s3\_read\_only\_policy\_arn) | n/a |
| <a name="output_user_data_chunk"></a> [user\_data\_chunk](#output\_user\_data\_chunk) | n/a |
