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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>4.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>4.0, < 5.0 |
| <a name="provider_aws.global"></a> [aws.global](#provider\_aws.global) | ~>4.0, < 5.0 |
| <a name="provider_aws.hosted_zone"></a> [aws.hosted\_zone](#provider\_aws.hosted\_zone) | ~>4.0, < 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.certificate](https://registry.terraform.io/providers/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.certificate_validation](https://registry.terraform.io/providers/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.distribution](https://registry.terraform.io/providers/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.s3](https://registry.terraform.io/providers/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_cloudwatch_log_group.edge_lambda](https://registry.terraform.io/providers/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.edge_lambda_custom](https://registry.terraform.io/providers/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.deployer](https://registry.terraform.io/providers/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.edge_lambda](https://registry.terraform.io/providers/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.edge_lambda_custom](https://registry.terraform.io/providers/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.edge_lambda](https://registry.terraform.io/providers/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.edge_lambda_custom](https://registry.terraform.io/providers/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.edge_lambda](https://registry.terraform.io/providers/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.edge_lambda_custom](https://registry.terraform.io/providers/aws/latest/docs/resources/lambda_function) | resource |
| [aws_route53_record.certificate_validation](https://registry.terraform.io/providers/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.distribution](https://registry.terraform.io/providers/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.bucket](https://registry.terraform.io/providers/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [random_pet.s3_origin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [archive_file.edge_lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.edge_lambda_custom](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.deployer](https://registry.terraform.io/providers/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.edge_lambda_role](https://registry.terraform.io/providers/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.edge_lambda](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alternative_domain_names"></a> [alternative\_domain\_names](#input\_alternative\_domain\_names) | Alternative domains under which frontend app will become available. | `list(string)` | `[]` | no |
| <a name="input_cache_disabled_path_patterns"></a> [cache\_disabled\_path\_patterns](#input\_cache\_disabled\_path\_patterns) | List of path patterns that won't be cached on CloudFront. | `list(string)` | `[]` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Comment that will be applied to all underlying resources that support it. | `string` | `"Frontend application environment"` | no |
| <a name="input_content_security_policy"></a> [content\_security\_policy](#input\_content\_security\_policy) | Content Security Policy header parameters. | `map(string)` | <pre>{<br>  "default-src": "'self' blob:",<br>  "font-src": "'self'",<br>  "img-src": "'self'",<br>  "object-src": "'none'",<br>  "script-src": "'self' 'unsafe-inline' 'unsafe-eval'",<br>  "style-src": "'self' 'unsafe-inline'",<br>  "worker-src": "blob:"<br>}</pre> | no |
| <a name="input_create_distribution_dns_records"></a> [create\_distribution\_dns\_records](#input\_create\_distribution\_dns\_records) | Set to false if you don't want to create DNS records for frontend. DNS domain validation will take place regardless of this flag. | `bool` | `true` | no |
| <a name="input_custom_headers"></a> [custom\_headers](#input\_custom\_headers) | Custom headers that may override headers returned by default. | `map(string)` | `{}` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CloudFront to return when an end user requests the root URL. | `string` | `"index.html"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain under which frontend app will become available. | `string` | n/a | yes |
| <a name="input_edge_functions"></a> [edge\_functions](#input\_edge\_functions) | Additional Lambda@Edge functions that tmay be added to CloudFront setup. | <pre>map(object({<br>    event_type     = string<br>    include_body   = bool<br>    lambda_code    = string<br>    lambda_runtime = string<br>  }))</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false if you don't want to create any resources. | `bool` | `true` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Route53 Zone ID to put DNS record for frontend app. | `string` | n/a | yes |
| <a name="input_lambda_log_retention_in_days"></a> [lambda\_log\_retention\_in\_days](#input\_lambda\_log\_retention\_in\_days) | CloudWatch log rentention time for Lambda@Edge functions. | `number` | `14` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of S3 bucket to store frontend app in. | `string` | n/a | yes |
| <a name="input_not_found_page_path"></a> [not\_found\_page\_path](#input\_not\_found\_page\_path) | Fallback file to return when 404 error is encountered | `string` | `"/index.html"` | no |
| <a name="input_scheduled_for_deletion"></a> [scheduled\_for\_deletion](#input\_scheduled\_for\_deletion) | Enable this to disconnect Lambda@Edge functions from CloudFront distribution and enables force\_Destroy on S3 bucket. It's necessary to proceed with module deletion. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to all underlying resources that support it. | `map(string)` | `{}` | no |
| <a name="input_wait_for_deployment"></a> [wait\_for\_deployment](#input\_wait\_for\_deployment) | If enabled, the resource will wait for the CloudFront distribution status to change from InProgress to Deployed. | `bool` | `false` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | WebACL ID for enabling whitelist access to CloudFront distribution. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cf_distribution_id"></a> [cf\_distribution\_id](#output\_cf\_distribution\_id) | CloudFront Distribution ID |
| <a name="output_deployer_policy_arn"></a> [deployer\_policy\_arn](#output\_deployer\_policy\_arn) | Policy that allows for performing S3 bucket actions & CloudFront invalidation. |
| <a name="output_edge_function_roles"></a> [edge\_function\_roles](#output\_edge\_function\_roles) | Map of IAM role ids for custom Lambda@Edge functions passed to module. |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | S3 Bucket Name |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | S3 Bucket ARN |
