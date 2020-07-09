# Database Secret Engine Policy
# Allows Full Read-Write Access

# List roles
path "${engine_path}/roles" {
  capabilities = ["list"]
}

# Create, read and delete roles
path "${engine_path}/roles/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read", "create", "delete"]
}

# List static roles
path "${engine_path}/static-roles" {
  capabilities = ["list"]
}

# Read, create and delete static roles
path "${engine_path}/static-roles/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read", "create", "delete"]
}

# Rotate roles
path "${engine_path}/rotate-role/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["create"]
}

# Generate credentials
path "${engine_path}/creds/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read"]
}

# Read static credentials
path "${engine_path}/static-creds/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read"]
}
