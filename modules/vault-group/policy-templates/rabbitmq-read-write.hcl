# RabbitMQ Secret Engine Policy
# Allows Full Read-Write Access

# Read, create and delete roles
path "${engine_path}/roles/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read", "create", "delete"]
}

# Generate credentials
path "${engine_path}/creds/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["read"]
}
