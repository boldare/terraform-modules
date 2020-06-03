# KV (Version 2) Secret Engine Policy
# Allows Read Access

# Read keys
path "${engine_path}/data/${group_name}/${environment}/*" {
  capabilities = ["read"]
}

# View metadata, list keys
path "${engine_path}/metadata/${group_name}/${environment}/*" {
  capabilities = ["list"]
}

path "${engine_path}/metadata/${group_name}" {
  capabilities = ["list"]
}

path "${engine_path}/metadata" {
  capabilities = ["list"]
}
