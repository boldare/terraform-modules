output "list_of_domains" {
  value       = local.domains
  description = "Domains that ACM certificate was created for"
}

output "certificate_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "ARN of ACM certificate"
}
