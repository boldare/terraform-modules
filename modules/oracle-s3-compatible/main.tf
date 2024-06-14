/**
 * # Oracle Cloud object storage s3 compatible
 * Module creating object storage bucket with user, groups and all permissions required to use it as drop in replacement for s3.
 *
 * **WARNING! This module by default allows doing HEAD request, it leads to "leaking" out names of OTHER buckets in compartment!**
 */

data "oci_objectstorage_namespace" "namespace" {
  compartment_id = var.compartment_id
}

resource "oci_objectstorage_bucket" "bucket" {
  #Required
  compartment_id = var.compartment_id
  name           = "${var.project_name}-${var.environment}"
  namespace      = data.oci_objectstorage_namespace.namespace.namespace

  access_type  = var.public_access ? "ObjectRead" : "NoPublicAccess"
  auto_tiering = var.auto_tiering ? "InfrequentAccess" : "Disabled"
  # https://blogs.oracle.com/cloud-infrastructure/post/introducing-object-storage-auto-tiering

}

resource "oci_identity_group" "group" {
  #Required
  compartment_id = var.tenancy_ocid
  description    = "group with access to ${var.project_name}-${var.environment} s3"
  name           = "${var.project_name}-${var.environment}-group"
}

resource "oci_identity_user" "bucket" {
  #Required
  compartment_id = var.tenancy_ocid
  description    = "User used for access to ${var.project_name}-${var.environment} S3"
  name           = "${var.project_name}-${var.environment}-bucket"
}

resource "oci_identity_user_group_membership" "group_member" {
  group_id = oci_identity_group.group.id
  user_id  = oci_identity_user.bucket.id
}

resource "oci_identity_customer_secret_key" "bucket_access" {
  display_name = "s3-access-keys"
  user_id      = oci_identity_user.bucket.id
}

resource "oci_identity_policy" "allow_head" {
  count          = var.allow_head ? 1 : 0
  compartment_id = var.compartment_id
  description    = "allow user to check for buckets s3 (HEAD)"
  name           = "${var.project_name}-${var.environment}-bucket-head-policy"
  statements     = ["Allow group ${oci_identity_group.group.name} to inspect buckets in compartment id ${var.compartment_id}"]
}

resource "oci_identity_policy" "allow_read" {
  compartment_id = var.compartment_id
  description    = "allow user to connect to ${var.project_name}-${var.environment} s3"
  name           = "${var.project_name}-${var.environment}-bucket-rw-policy"
  statements     = ["Allow group ${oci_identity_group.group.name} to manage objects in compartment id ${var.compartment_id} where all {target.bucket.name='${oci_objectstorage_bucket.bucket.name}', any {request.permission='OBJECT_INSPECT', request.permission='OBJECT_CREATE', request.permission='OBJECT_DELETE', request.permission='OBJECT_READ' }}"]
}
