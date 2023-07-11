terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = ">= 4.0, < 5.0"
    # on aws "< 3" aws.aws_acm_certificate.subject_alternative_names order randomizes every time which forces recreation
  }
}
