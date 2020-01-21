#!/usr/bin/env bash
set -e
BUCKET_URI="s3://${s3_bucket_name}/"
SSH_USER=${ssh_user}
MARKER="# KEYS_BELOW_WILL_BE_UPDATED_BY_TERRAFORM"
KEYS_FILE=/home/$SSH_USER/.ssh/authorized_keys
TEMP_KEYS_FILE=$(mktemp /tmp/authorized_keys.XXXXXX)
PUB_KEYS_DIR=/home/$SSH_USER/pub_key_files/
PATH=/usr/local/bin:$PATH

mkdir -p "$PUB_KEYS_DIR"

# Add marker, if not present, and copy static content.
grep -Fxq "$MARKER" "$KEYS_FILE" || echo -e "\n$MARKER" >> "$KEYS_FILE"
line=$(grep -n "$MARKER" "$KEYS_FILE" | cut -d ":" -f 1)
head -n "$line" "$KEYS_FILE" > "$TEMP_KEYS_FILE"

# Synchronize the keys from the bucket.
aws s3 sync --delete --exact-timestamps "$BUCKET_URI" "$PUB_KEYS_DIR"
for filename in "$PUB_KEYS_DIR"/*; do
    [ -f "$filename" ] || continue
    sed 's/\n\?$/\n/' < "$filename" >> "$TEMP_KEYS_FILE"
done

# Move the new authorized keys in place.
chown "$SSH_USER:$SSH_USER" "$KEYS_FILE"
chmod 600 "$KEYS_FILE"
mv "$TEMP_KEYS_FILE" "$KEYS_FILE"
if [[ $(command -v "selinuxenabled") ]]; then
    restorecon -R -v "$KEYS_FILE"
fi
