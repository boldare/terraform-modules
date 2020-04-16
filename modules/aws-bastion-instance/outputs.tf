output "bastion_security_group_id" {
  value       = var.create ? aws_security_group.bastion_host[0].id : null
  description = "Bastion Security Group identifier. Can be used to allow broader access to bastion instance."
}

output "bastion_iam_role" {
  value       = var.create ? aws_iam_role.bastion[0].id : null
  description = "Bastion IAM role identifier. Can be used to attach additional IAM policies to it."
}

output "bastion_ip" {
  value       = var.create ? (var.eip_id != null ? aws_eip_association.bastion[0].public_ip : aws_eip.bastion[0].public_ip) : null
  description = "Bastion Public IP."
}
