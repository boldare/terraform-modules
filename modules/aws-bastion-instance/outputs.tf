output "bastion_security_group_id" {
  value       = aws_security_group.bastion_host.id
  description = "Bastion Security Group identifier. Can be used to allow broader access to bastion instance."
}

output "bastion_iam_role" {
  value       = aws_iam_role.bastion.id
  description = "Bastion IAM role identifier. Can be used to attach additional IAM policies to it."
}

output "bastion_ip" {
  value       = var.eip_id ? aws_eip_association.bastion[0].public_ip : aws_eip.bastion[0].public_ip
  description = "Bastion Public IP."
}
