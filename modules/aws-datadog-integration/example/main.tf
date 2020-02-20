module "datadog" {
  source = "../"

  # Pass secret dynamically
  api_key                 = var.dd_api_key
  # This value is created during Datadog integration setup
  aws_account_external_id = "35f99da91e91b67656689f5765b758e5"
  aws_region              = "eu-west-1"
  site                    = "datadoghq.eu"
}
