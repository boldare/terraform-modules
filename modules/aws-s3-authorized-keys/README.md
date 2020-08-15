## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.49, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.49, < 4.0 |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Name of bucket to store SSH keys | `string` | n/a | yes |
| keys\_update\_frequency | How often keys should be fetched from S3 bucket | `string` | `"0 * * * *"` | no |
| ssh\_keys | n/a | <pre>list(object({<br>    name       = string,<br>    public_key = string<br>  }))</pre> | n/a | yes |
| ssh\_user | User to use to login to instance | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| keys\_s3\_bucket | n/a |
| keys\_s3\_read\_only\_policy\_arn | n/a |
| user\_data\_chunk | n/a |

