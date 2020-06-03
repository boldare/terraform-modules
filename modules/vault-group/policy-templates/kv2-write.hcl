# KV (Version 2) Secret Engine Policy
# Allows Write Access

# Perform CRUD on a key
path "${engine_path}/data/${group_name}/${environment}/*"
{
  capabilities = ["create", "update", "delete"]
}

# Mark a key version as deleted
path "${engine_path}/delete/${group_name}/${environment}/*"
{
  capabilities = ["update"]
}

# Undelete a key version
path "${engine_path}/undelete/${group_name}/${environment}/*"
{
  capabilities = ["update"]
}

# Delete a key version forever
path "${engine_path}/destroy/${group_name}/${environment}/*"
{
  capabilities = ["update"]
}

# View & edit metadata, list keys
path "${engine_path}/metadata/${group_name}/${environment}/*"
{
  capabilities = ["read", "delete"]
}
