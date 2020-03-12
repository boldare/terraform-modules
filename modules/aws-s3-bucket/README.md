# AWS S3 Bucket  
Creates a S3 bucket.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| acl | Canned ACL for S3 bucket | `string` | n/a | yes |
| bucket\_cors | S3 Bucket CORS | <pre>list(object({<br>    allowed_origins = list(string)<br>    allowed_methods = list(string)<br>    max_age_seconds = number<br>    allowed_headers = list(string)<br>  }))</pre> | `[]` | no |
| bucket\_name | S3 Bucket Name | `string` | n/a | yes |
| bucket\_policy | S3 Bucket Policy | `string` | n/a | yes |
| force\_destroy | Whether to force destroy a bucket in case of removal from Terraform. | `bool` | `false` | no |
| no\_public\_access | Block all public access to bucket | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | n/a |
| bucket\_iam\_policy\_arn | n/a |
| bucket\_id | n/a |

