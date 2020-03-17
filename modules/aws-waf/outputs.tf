output "web_acl_id" {
  value       = aws_waf_web_acl.waf_acl[0].id
  description = "Web Application Firewall service ID limiting access to CloudFront distribution to given IP adresses."
}
