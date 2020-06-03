# RabbitMQ Secret Engine Policy
# Allows Read Access

# Read roles
path "${engine_path}/roles/${group_name}${separator}${environment}${separator}+" {
  capabilities = ["read"]
}

# Generate credentials
path "${engine_path}/creds/${group_name}${separator}${environment}${separator}+" {
  capabilities = ["read"]
}
