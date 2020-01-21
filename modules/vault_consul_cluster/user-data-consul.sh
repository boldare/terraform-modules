#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

/opt/consul/bin/run-consul --server \
  --cluster-tag-key "${consul_cluster_tag_key}" \
  --cluster-tag-value "${consul_cluster_tag_value}" \
  --enable-gossip-encryption \
  --gossip-encryption-key "${consul_gossip_key}" \

${additional_user_data}
