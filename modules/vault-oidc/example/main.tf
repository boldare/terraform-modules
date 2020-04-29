provider "vault" {
  version = "~> 2.10"
  address = "https://vault.example.com"
}

data "vault_policy_document" "default_user_policy" {
  # Allow tokens to look up their own properties
  rule {
    path         = "auth/token/lookup-self"
    capabilities = ["read"]
  }

  # Allow tokens to renew themselves
  rule {
    path         = "auth/token/renew-self"
    capabilities = ["update"]
  }

  # Allow tokens to revoke themselves
  rule {
    path         = "auth/token/revoke-self"
    capabilities = ["update"]
  }

  # Allow a token to look up its own capabilities on a path
  rule {
    path         = "sys/capabilities-self"
    capabilities = ["update"]
  }

  # Allow a token to look up its own entity by id or name
  rule {
    path         = "identity/entity/id/{{identity.entity.id}}"
    capabilities = ["read"]
  }
  rule {
    path         = "identity/entity/name/{{identity.entity.name}}"
    capabilities = ["read"]
  }
  # Allow a token to look up its resultant ACL from all policies. This is useful
  # for UIs. It is an internal path because the format may change at any time
  # based on how the internal ACL features and capabilities change.
  rule {
    path         = "sys/internal/ui/resultant-acl"
    capabilities = ["read"]
  }

  # Allow a token to renew a lease via lease_id in the request body; old path for old clients, new path for newer
  rule {
    path         = "sys/renew"
    capabilities = ["update"]
  }
  rule {
    path         = "sys/leases/renew"
    capabilities = ["update"]
  }

  # Allow looking up lease properties. This requires knowing the lease ID ahead of time and does not divulge any
  # sensitive information.
  rule {
    path         = "sys/leases/lookup"
    capabilities = ["update"]
  }

  # Allow a token to manage its own cubbyhole
  rule {
    path         = "cubbyhole/*"
    capabilities = ["create", "read", "update", "delete", "list"]
  }

  # Allow a token to wrap arbitrary values in a response-wrapping token
  rule {
    path         = "sys/wrapping/wrap"
    capabilities = ["update"]
  }

  # Allow a token to look up the creation time and TTL of a given response-wrapping token
  rule {
    path         = "sys/wrapping/lookup"
    capabilities = ["update"]
  }

  # Allow a token to unwrap a response-wrapping token. This is a convenience to avoid client token swapping since
  # this is also part of the response wrapping policy.
  rule {
    path         = "sys/wrapping/unwrap"
    capabilities = ["update"]
  }

  # Allow general purpose tools
  rule {
    path         = "sys/tools/hash"
    capabilities = ["update"]
  }

  rule {
    path         = "sys/tools/hash/*"
    capabilities = ["update"]
  }

  # Allow checking the status of a Control Group request if the user has the accessor
  rule {
    path         = "sys/control-group/request"
    capabilities = ["update"]
  }

}

resource "vault_policy" "default_user_policy" {
  name   = "default"
  policy = data.vault_policy_document.default_user_policy.hcl
}

module "gitlab" {
  source = "../"

  role_name   = "gitlab"
  path        = "gitlab"
  description = "This auth method gives access to Vault to everyone who has access to our GitLab instance."

  vault_domain           = "vault.example.com"
  domain                 = "gitlab.example.com"
  client_id              = "<client id generated in gitlab>"
  client_secret          = var.gitlab_client_secret
  default_token_policies = [vault_policy.default_user_policy.id]
  scopes                 = ["profile", "email"]
  ttl                    = 12 * 60 * 60
}
