## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| alternative\_domain\_names | Alternative domains under which frontend app will become available. | `list(string)` | `[]` | no |
| cache\_disabled\_path\_patterns | List of path patterns that won't be cached on CloudFront. | `list(string)` | `[]` | no |
| comment | Comment that will be applied to all underlying resources that support it. | `string` | `"Frontend application environment"` | no |
| content\_security\_policy | Content Security Policy header parameters. | `map(string)` | <pre>{<br>  "default-src": "'self' blob:",<br>  "font-src": "'self'",<br>  "img-src": "'self'",<br>  "object-src": "'none'",<br>  "script-src": "'self' 'unsafe-inline' 'unsafe-eval'",<br>  "style-src": "'self' 'unsafe-inline'",<br>  "worker-src": "blob:"<br>}</pre> | no |
| domain\_name | Domain under which frontend app will become available. | `string` | n/a | yes |
| hosted\_zone\_id | Route53 Zone ID to put DNS record for frontend app. | `string` | n/a | yes |
| name | Name of S3 bucket to store frontend app in. | `string` | n/a | yes |
| tags | Tags that will be applied to all underlying resources that support it. | `map(string)` | `{}` | no |
| wait\_for\_deployment | If enabled, the resource will wait for the CloudFront distribution status to change from InProgress to Deployed. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_distribution\_id | n/a |
| deployer\_policy\_arn | n/a |
| s3\_bucket | n/a |
| s3\_bucket\_arn | n/a |

