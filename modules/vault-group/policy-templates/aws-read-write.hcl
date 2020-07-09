# AWS Secret Engine Policy
# Allows Full Read-Write Access

# List roles
path "${engine_path}/roles" {
  capabilities = ["list"]
}

# Read, write and delete roles
path "${engine_path}/roles/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read", "create", "delete"]
}

# Generate credentials
path "${engine_path}/creds/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read"]
}

path "${engine_path}/sts/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read"]
}
