resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  dynamic "cors_rule" {
    for_each = var.bucket_cors

    content {
      allowed_origins = cors_rule.value.allowed_origins
      allowed_methods = cors_rule.value.allowed_methods
      max_age_seconds = cors_rule.value.max_age_seconds
      allowed_headers = cors_rule.value.allowed_headers
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  count  = var.no_public_access ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "read_write_bucket_access" {
  statement {
    effect    = "Allow"
    actions   = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.bucket.arn]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "bucket_policy" {
  name        = "${var.bucket_name}-read-write"
  description = "Allows basic read and write access to ${var.bucket_name} bucket"
  policy      = data.aws_iam_policy_document.read_write_bucket_access.json
}
