data "aws_iam_policy_document" "execution_role_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_role_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "execution_role_secrets" {
  statement {
    sid       = "GetSecrets"
    effect    = "Allow"
    actions   = [
      "secretsmanager:GetSecretValue"
    ]
    resources = var.secret_arns
  }
}

resource "aws_iam_role_policy" "execution_role_secrets" {
  name   = "Secrets"
  role   = aws_iam_role.execution_role.id
  policy = data.aws_iam_policy_document.execution_role_secrets.json
}

resource "aws_iam_role" "execution_role" {
  name               = "${var.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.execution_role_assume.json
}

resource "aws_iam_role" "task_role" {
  name               = "${var.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_role_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.execution_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "policies" {
  count = length(var.attached_policies)

  policy_arn = var.attached_policies[count.index]
  role       = aws_iam_role.task_role.id
}

data "aws_iam_policy_document" "iam_role_attacher" {
  statement {
    sid       = "PassSelectedRole"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.execution_role.arn, aws_iam_role.task_role.arn]
  }
}

resource "aws_iam_policy" "iam_role_attacher" {
  name_prefix = "${var.name}-iam-role-attacher"
  policy      = data.aws_iam_policy_document.iam_role_attacher.json
}
