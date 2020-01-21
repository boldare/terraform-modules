output "bastion_security_group_id" {
  value = aws_security_group.bastion_host.id
}

output "bastion_iam_role" {
  value = aws_iam_role.bastion.id
}
