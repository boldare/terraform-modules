# Perform CRUD on a key
path "kv/data/${group_name}/${environment}/*"
{
  capabilities = ["create", "update", "delete"]
}

# Mark a key version as deleted
path "kv/delete/${group_name}/${environment}/*"
{
  capabilities = ["update"]
}

# Undelete a key version
path "kv/undelete/${group_name}/${environment}/*"
{
  capabilities = ["update"]
}

# Delete a key version forever
path "kv/destroy/${group_name}/${environment}/*"
{
  capabilities = ["update"]
}

# View & edit metadata, list keys
path "kv/metadata/${group_name}/${environment}/*"
{
  capabilities = ["read", "delete"]
}
