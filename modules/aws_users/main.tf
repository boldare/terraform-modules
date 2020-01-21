resource "aws_iam_user" "users" {
  for_each = var.users

  name          = each.value.email
  force_destroy = true
  tags          = {
    name  = each.key
    email = each.value.email
  }
}