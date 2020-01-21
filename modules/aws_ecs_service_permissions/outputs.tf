output "task_role_id" {
  value = aws_iam_role.task_role.id
}

output "task_role_arn" {
  value = aws_iam_role.task_role.arn
}

output "execution_role_id" {
  value = aws_iam_role.execution_role.id
}

output "execution_role_arn" {
  value = aws_iam_role.execution_role.arn
}

output "iam_role_attacher_policy_arn" {
  value = aws_iam_policy.iam_role_attacher.arn
}
