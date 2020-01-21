output "user_ids" {
  value = zipmap(keys(aws_iam_user.users), values(aws_iam_user.users)[*].id)
}