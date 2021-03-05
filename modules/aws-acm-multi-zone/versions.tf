terraform {
  required_version = ">= 0.12.6, < 0.14"

  required_providers {
    aws = ">= 3.0, < 4.0"
    # on aws "< 3" aws.aws_acm_certificate.subject_alternative_names order randomizes every time which forces recreation
  }
}
