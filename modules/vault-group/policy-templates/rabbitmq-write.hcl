# RabbitMQ Secret Engine Policy
# Allows Write Access

# Create and delete roles
path "${engine_path}/roles/${group_name}${separator}${environment}${separator}*" {
  capabilities = ["create", "update", "delete"]
}
