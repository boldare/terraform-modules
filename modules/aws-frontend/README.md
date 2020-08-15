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

If you wish to gracefully destroy this module, make sure to set `scheduled_for_deletion` parameter to `true`.  
Otherwise you won't be able to remove non-empty S3 bucket or Lambda@Edge functions still connected to CloudFront.  
Setting this flag to `true` may render your environment unusable, so make sure to migrate gracefully to a different  
environment by provisioning replacement and swapping DNS entries first.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | ~>3.0 |
| aws | ~>3.0 |
| aws | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | ~>3.0 ~>3.0 >= 3.0, < 4.0 |
| aws.global | ~>3.0 ~>3.0 >= 3.0, < 4.0 |
| aws.hosted\_zone | ~>3.0 ~>3.0 >= 3.0, < 4.0 |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alternative\_domain\_names | Alternative domains under which frontend app will become available. | `list(string)` | `[]` | no |
| cache\_disabled\_path\_patterns | List of path patterns that won't be cached on CloudFront. | `list(string)` | `[]` | no |
| comment | Comment that will be applied to all underlying resources that support it. | `string` | `"Frontend application environment"` | no |
| content\_security\_policy | Content Security Policy header parameters. | `map(string)` | <pre>{<br>  "default-src": "'self' blob:",<br>  "font-src": "'self'",<br>  "img-src": "'self'",<br>  "object-src": "'none'",<br>  "script-src": "'self' 'unsafe-inline' 'unsafe-eval'",<br>  "style-src": "'self' 'unsafe-inline'",<br>  "worker-src": "blob:"<br>}</pre> | no |
| create\_distribution\_dns\_records | Set to false if you don't want to create DNS records for frontend. DNS domain validation will take place regardless of this flag. | `bool` | `true` | no |
| custom\_headers | Custom headers that may override headers returned by default. | `map(string)` | `{}` | no |
| domain\_name | Domain under which frontend app will become available. | `string` | n/a | yes |
| edge\_functions | Additional Lambda@Edge functions that tmay be added to CloudFront setup. | <pre>map(object({<br>    event_type     = string<br>    include_body   = bool<br>    lambda_code    = string<br>    lambda_runtime = string<br>  }))</pre> | `{}` | no |
| enabled | Set to false if you don't want to create any resources. | `bool` | `true` | no |
| hosted\_zone\_id | Route53 Zone ID to put DNS record for frontend app. | `string` | n/a | yes |
| lambda\_log\_retention\_in\_days | CloudWatch log rentention time for Lambda@Edge functions. | `number` | `14` | no |
| name | Name of S3 bucket to store frontend app in. | `string` | n/a | yes |
| scheduled\_for\_deletion | Enable this to disconnect Lambda@Edge functions from CloudFront distribution and enables force\_Destroy on S3 bucket. It's necessary to proceed with module deletion. | `bool` | `false` | no |
| tags | Tags that will be applied to all underlying resources that support it. | `map(string)` | `{}` | no |
| wait\_for\_deployment | If enabled, the resource will wait for the CloudFront distribution status to change from InProgress to Deployed. | `bool` | `false` | no |
| web\_acl\_id | WebACL ID for enabling whitelist access to CloudFront distribution. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_distribution\_id | CloudFront Distribution ID |
| deployer\_policy\_arn | Policy that allows for performing S3 bucket actions & CloudFront invalidation. |
| edge\_function\_roles | Map of IAM role ids for custom Lambda@Edge functions passed to module. |
| s3\_bucket | S3 Bucket Name |
| s3\_bucket\_arn | S3 Bucket ARN |

