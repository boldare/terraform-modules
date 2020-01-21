# TODO Add multiple user support & permissions to the script

resource "aws_s3_bucket" "keys" {
  bucket = var.bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "key" {
  bucket = aws_s3_bucket.keys.bucket

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

data "template_file" "update_ssh_authorized_keys" {
  template = file("${path.module}/templates/update_ssh_authorized_keys.sh")
  vars = {
    ssh_user       = var.ssh_user,
    s3_bucket_name = var.bucket_name
  }
}

data "template_file" "user_data_chunk" {
  template = file("${path.module}/templates/user_data_chunk.sh")
  vars = {
    ssh_user                   = var.ssh_user,
    keys_update_frequency      = var.keys_update_frequency,
    update_ssh_authorized_keys = data.template_file.update_ssh_authorized_keys.rendered
  }
}

resource "aws_s3_bucket_object" "ssh_keys" {
  count = length(var.ssh_keys)

  bucket  = aws_s3_bucket.keys.bucket
  key     = var.ssh_keys[count.index].name
  content = var.ssh_keys[count.index].public_key
}

data "aws_iam_policy_document" "read_only" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.keys.arn]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "s3:HeadObject",
      "s3:GetObject",
      "s3:GetObjectAcl"
    ]
    resources = ["${aws_s3_bucket.keys.arn}/*"]
  }
}

resource "aws_iam_policy" "read_only" {
  name   = "${var.bucket_name}-read-only"
  policy = data.aws_iam_policy_document.read_only.json
}
