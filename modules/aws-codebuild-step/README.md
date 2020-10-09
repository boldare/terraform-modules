# AWS codebuild step  
AWS codebuild step is very simple module for building project using just one object in terraform.  
This module creates roles and codebuild project.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| build\_image | Name of docker/aws image used as system used on building | `string` | n/a | yes |
| build\_timeout | Time in minutes that build is going to be allowed to run | `string` | `"60"` | no |
| buildspec\_path | Path inside artifacts from previous step to get buildspec file | `string` | n/a | yes |
| compute\_size | Compute resources the build project will use | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| compute\_type | The type of build environment to use for related builds (linux, gpu, windows, arm) | `string` | `"LINUX_CONTAINER"` | no |
| description | Description of that codebuild step visible on AWS panel | `string` | n/a | yes |
| environment | Name of environment which is added to tag | `string` | `"None"` | no |
| environment\_variable | list of environment variables set inside build container | `list(map(string))` | `[]` | no |
| pipeline\_s3\_arn | Arn of S3 where artifacts are going to be stored to | `string` | n/a | yes |
| project\_name | Name of that project used as name of codebuild step | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| name | Name of project used for codepipeline |
| role | Used for attaching policy to role to give codebuild access to additional resources |

