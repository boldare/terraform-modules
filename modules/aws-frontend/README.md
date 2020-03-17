# AWS Frontend

This module creates complete environment for frontend applications:
- S3 bucket to store SPA files
- CloudFront distribution to ensure fast access and caching
- Lambda@Edge to ensure proper CORS headers
- ACM certificate for HTTPS (created via `aws.global` provider)
- Route53 entries to set user-friendly domain (created via `aws.hosted_zone` provider)

You may want to set custom providers to deploy some parts of frontend:
- S3 bucket & IAM policies is deployed using the default `aws` provider
- Lambda@Edge & ACM certificate have to be created on `us-east-1` region (via `aws.global` provider),
- Route53 entries can be on a different AWS account (via `aws.hosted_zone` provider)

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |
| aws.global | n/a |
| aws.hosted\_zone | n/a |
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
| web\_acl\_id | WebACL ID for enabling whitelist access to CloudFront distribution. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cf\_distribution\_id | CloudFront Distribution ID |
| deployer\_policy\_arn | Policy that allows for performing S3 bucket actions & CloudFront invalidation. |
| s3\_bucket | S3 Bucket Name |
| s3\_bucket\_arn | S3 Bucket ARN |

