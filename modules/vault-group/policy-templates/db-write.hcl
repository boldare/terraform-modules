# Database Secret Engine Policy
# Allows Write Access

# Create and delete roles
path "${engine_path}/roles/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["create", "update", "delete"]
}

# Rotate roles
path "${engine_path}/rotate-role/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["create"]
}

# Create and delete static roles
path "${engine_path}/static-roles/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["create", "update", "delete"]
}
