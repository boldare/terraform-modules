module "certbot_lambda" {
  source = "../"

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
