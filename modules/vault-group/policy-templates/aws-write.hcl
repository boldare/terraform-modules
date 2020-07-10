# Database Secret Engine Policy
# Allows Write Access

path "${engine_path}/roles/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["create", "update", "delete"]
}
