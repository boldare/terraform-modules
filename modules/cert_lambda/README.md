# Cert Lambda

Complete infrastructure to provide certificates for a domain in a Route53 zone. Certificates are stored on S3 bucket (encrypted by KMS key).

## Usage Example

```hcl-terraform

module "certbot_lambda" {
  source = "../../modules/cert_lambda"

  name_prefix = "service"

  refresh_frequency_cron = "0 */12 * * ? *" # Every 12 hours
  kms_key_id             = "some_kms_key_id"
  hosted_zone_id         = "hosted_zone_id"
  s3_bucket_name         = "bucket"
  owner_email            = "devops-team@domain.org"
  s3_bucket_prefix       = "s3_folder"
  domain_names           = [
    "my.domain.org", # Primary domain
    "*.my.domain.org"
  ]
}

```

## Development

If you modified `requirements.txt` contents, please update layer zip file, which has to be built using an actual Amazon Linux 2:

```bash
cd src
packer build requirements.json
```
