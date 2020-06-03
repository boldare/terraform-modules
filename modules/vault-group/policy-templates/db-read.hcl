# Database Secret Engine Policy
# Allows Read Access

# List roles
path "${engine_path}/roles" {
  capabilities = ["list"]
}

# Read roles
path "${engine_path}/roles/${group_name}${separator}${environment}${separator}+" {
  capabilities = ["read"]
}

# List static roles
path "${engine_path}/static-roles" {
  capabilities = ["list"]
}
# Read static roles
path "${engine_path}/static-roles/${group_name}${separator}${environment}${separator}+" {
  capabilities = ["read"]
}

# Generate credentials
path "${engine_path}/creds/${group_name}${separator}${environment}${separator}+" {
  capabilities = ["read"]
}

# Read static credentials
path "${engine_path}/static-creds/${group_name}${separator}${environment}${separator}+" {
  capabilities = ["read"]
}
