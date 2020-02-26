/**
 * AWS IAM User Group
 * This module creates IAM user group, attaches users and policies to it.
 */

# ----------------------------------------------------------------------------------------------------------------------
# USER GROUP
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_iam_group" "this" {
  name = var.name
  path = var.path
}

# ----------------------------------------------------------------------------------------------------------------------
# POLICIES
# Allow users to perform actions in AWS account
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_iam_group_policy_attachment" "this" {
  for_each = var.attached_policy_arns

  group      = aws_iam_group.this.id
  policy_arn = each.value
}

# ----------------------------------------------------------------------------------------------------------------------
# USERS
# Assign selected users to the group
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_user_group_membership" "this" {
  for_each = var.users

  groups = [aws_iam_group.this.id]
  user   = each.value
}
