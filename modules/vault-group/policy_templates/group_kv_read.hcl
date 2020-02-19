# Read keys
path "kv/data/${group_name}/${environment}/*" {
  capabilities = ["read"]
}

# View metadata, list keys
path "kv/metadata/${group_name}/${environment}/*" {
  capabilities = ["list"]
}

path "kv/metadata/${group_name}" {
  capabilities = ["list"]
}

path "kv/metadata" {
  capabilities = ["list"]
}
