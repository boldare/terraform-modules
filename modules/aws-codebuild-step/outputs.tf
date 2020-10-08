output "name" {
  value       = var.project_name
  description = "Name of project used for codepipeline"
}

output "role" {
  value       = aws_iam_role.role.id
  description = "Used for attaching policy to role to give codebuild access to additional resources"
}
