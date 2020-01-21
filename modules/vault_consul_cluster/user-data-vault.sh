#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "Launching Consul client..."
/opt/consul/bin/run-consul --client \
  --cluster-tag-key "${consul_cluster_tag_key}" \
  --cluster-tag-value "${consul_cluster_tag_value}" \
  --enable-gossip-encryption \
  --gossip-encryption-key "${consul_gossip_key}"

echo "Mapping Vault domain name to localhost..."
echo "127.0.0.1   ${vault_domain_name}" >>/etc/hosts

echo "Creating Vault scripts..."

cat <<EOF >/usr/local/bin/get-certs.sh
#!/bin/bash
set -e
CERT_DIR="/opt/vault/tls"
sudo aws s3 cp "s3://${cert_s3_bucket_name}/${cert_s3_bucket_tls_cert_file}" "\$${CERT_DIR}/vault.crt.pem"
sudo aws s3 cp "s3://${cert_s3_bucket_name}/${cert_s3_bucket_tls_key_file}" "\$${CERT_DIR}/vault.key.pem"
sudo chown -R vault:vault "\$${CERT_DIR}/"
sudo chmod -R 600 "\$${CERT_DIR}"
sudo chmod 700 "\$${CERT_DIR}"
EOF
chmod 755 /usr/local/bin/get-certs.sh

cat <<EOF >/usr/local/bin/update-vault-certs.sh
#!/bin/bash
set -e
/usr/local/bin/get-certs.sh
sudo killall -1 vault
EOF
chmod 755 /usr/local/bin/update-vault-certs.sh

cat <<"EOF" >/etc/cron.d/vault_schedule
${cert_refresh_cron} root /usr/local/bin/update-vault-certs.sh >> /var/log/update-vault-certs.log 2>&1
EOF

echo "Starting cron service..."
sudo service crond start

echo "Fetching certificates..."
/usr/local/bin/get-certs.sh

echo "Launching Vault after boot..."

export VAULT_ADDR="https://${vault_domain_name}:8200"

echo "Configuring Vault..."

readonly EC2_INSTANCE_METADATA_URL="http://169.254.169.254/latest/meta-data"

function lookup_path_in_instance_metadata {
  local -r path="$1"
  curl --silent --location "$EC2_INSTANCE_METADATA_URL/$path/"
}

function get_instance_ip_address {
  lookup_path_in_instance_metadata "local-ipv4"
}

function create_vault_config {
  local instance_ip_address="$(get_instance_ip_address)"
  local port=8200
  local cluster_port=$(($port + 1))

  api_addr="https://$${instance_ip_address}:$${port}"
  cluster_addr="https://$${instance_ip_address}:$${cluster_port}"

  cat <<EOF >/opt/vault/config/default.hcl
ui = true

listener "tcp" {
  address         = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_cert_file   = "/opt/vault/tls/vault.crt.pem"
  tls_key_file    = "/opt/vault/tls/vault.key.pem"
  tls_disable_client_certs = true
}

storage "s3" {
  region     = "${aws_region}"
  bucket     = "${s3_backend_bucket}"
  kms_key_id = "${kms_key_id}"
}

ha_storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
  scheme  = "http"
  service = "vault"
}

seal "awskms" {
  region     = "${aws_region}"
  kms_key_id = "${kms_key_id}"
}

cluster_addr  = "$${cluster_addr}"
api_addr      = "$${api_addr}"
EOF
}

echo "Launching Vault..."
/opt/vault/bin/run-vault \
  --tls-cert-file "/opt/vault/tls/vault.crt.pem" \
  --tls-key-file "/opt/vault/tls/vault.key.pem" \
  --enable-auto-unseal \
  --auto-unseal-kms-key-id "${kms_key_id}" \
  --auto-unseal-kms-key-region "${aws_region}"

create_vault_config
sudo killall -1 vault

${additional_user_data}

echo "Waiting for Vault server ($${VAULT_ADDR}) to start..."
until curl -XGET -s --insecure "$${VAULT_ADDR}/v1/sys/health"; do
  echo 'Vault is still booting up...'
  sleep 2
done

echo "Initialization finished!"
