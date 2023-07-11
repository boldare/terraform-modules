output "s3_access_key" {
  description = "S3 compatible access key for backend"
  value       = oci_identity_customer_secret_key.bucket_access.id
}
output "s3_access_secret" {
  description = "S3 compatible secret key for backend"
  value       = oci_identity_customer_secret_key.bucket_access.key
}
output "namespace" {
  description = "Namespace id of your account"
  value       = data.oci_objectstorage_namespace.namespace.namespace
}
output "name" {
  description = "Name of the bucket"
  value       = oci_objectstorage_bucket.bucket.name
}
output "s3_endpoint" {
  description = "Endpoint used for accessing S3 by backend and token authenticated files"
  value       = "https://${data.oci_objectstorage_namespace.namespace.namespace}.compat.objectstorage.${var.region}.oraclecloud.com"
}
output "s3_url" {
  description = "Url used for accessing publicly accessible files"
  value       = "https://objectstorage.${var.region}.oraclecloud.com/n/${data.oci_objectstorage_namespace.namespace.namespace}/b/${oci_objectstorage_bucket.bucket.name}/o/"
}
