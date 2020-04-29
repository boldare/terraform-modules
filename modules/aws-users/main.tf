resource "aws_iam_user" "users" {
  for_each = var.users

  name          = each.value.email
  path          = var.path
  force_destroy = true
  tags = merge(var.tags, {
    name  = each.key
    email = each.value.email
  })
}
