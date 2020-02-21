## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| bucket\_cors | S3 Bucket CORS | <pre>list(object({<br>    allowed_origins = list(string)<br>    allowed_methods = list(string)<br>    max_age_seconds = number<br>    allowed_headers = list(string)<br>  }))</pre> | `[]` | no |
| bucket\_name | S3 Bucket Name | `string` | n/a | yes |
| no\_public\_access | Block all public access to bucket | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | n/a |
| bucket\_policy\_arn | n/a |

