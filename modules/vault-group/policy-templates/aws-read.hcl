# AWS Secret Engine Policy
# Allows Read Access

# List roles
path "${engine_path}/roles" {
  capabilities = ["list"]
}

# Read roles
path "${engine_path}/roles/${group_name}${separator}${environment}*" {
  capabilities = ["read"]
}

# Generate credentials
path "${engine_path}/creds/${group_name}${separator}${environment}*" {
  capabilities = ["read"]
}

path "${engine_path}/sts/${group_name}${separator}${environment}*" {
  capabilities = ["read"]
}
