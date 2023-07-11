# AWS codebuild step
AWS codebuild step is very simple module for creating CodeBuild project using just one object in terraform.
This module creates roles and codebuild project.

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
| [aws_codebuild_project.project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_s3_arn"></a> [artifact\_s3\_arn](#input\_artifact\_s3\_arn) | Arn of S3 where artifacts are going to be stored to | `string` | n/a | yes |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Name of docker/aws image used as system used on building | `string` | n/a | yes |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | Time in minutes that build is going to be allowed to run | `string` | `"60"` | no |
| <a name="input_buildspec_path"></a> [buildspec\_path](#input\_buildspec\_path) | Path inside artifacts from previous step to get buildspec file | `string` | n/a | yes |
| <a name="input_compute_size"></a> [compute\_size](#input\_compute\_size) | Compute resources the build project will use | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_compute_type"></a> [compute\_type](#input\_compute\_type) | The type of build environment to use for related builds (linux, gpu, windows, arm) | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of that codebuild step visible on AWS panel | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | list of environment variables set inside build container | `list(map(string))` | `[]` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of that project used as name of codebuild step | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags set on codebuild project | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of project used for codepipeline |
| <a name="output_role"></a> [role](#output\_role) | Used for attaching policy to role to give codebuild access to additional resources |
