module "developers" {
  source = "../"

  name                 = "Developers"
  attached_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
  users                = [
    "developer-iam-user-1",
    "developer-iam-user-2"
  ]
}
