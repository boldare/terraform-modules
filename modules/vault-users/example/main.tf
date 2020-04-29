module "users" {
  source = "../"

  auth_backend_accessor = var.gitlab_auth_accessor

  # The email specified here must correspond to the one used in GitLab
  users = {
    krzysztof_miemiec = "krzysztof.miemiec@boldare.com"
  }
}
