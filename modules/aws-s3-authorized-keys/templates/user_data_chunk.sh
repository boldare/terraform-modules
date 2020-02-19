function ssh_authorized_keys_addition() {
  local SSH_USER="${ssh_user}"
  cat <<"EOF" >"/home/$SSH_USER/update_ssh_authorized_keys.sh"
${update_ssh_authorized_keys}
EOF
  chmod 755 "/home/$SSH_USER/update_ssh_authorized_keys.sh"
  chown "$SSH_USER:$SSH_USER" "/home/$SSH_USER/update_ssh_authorized_keys.sh"

  cat <<"EOF" >>"/home/$SSH_USER/.ssh/config"
Host *
    StrictHostKeyChecking no
EOF
  chmod 600 "/home/$SSH_USER/.ssh/config"
  chown "$SSH_USER:$SSH_USER" "/home/$SSH_USER/.ssh/config"

  # Execute now
  su "$SSH_USER" -c "/home/$SSH_USER/update_ssh_authorized_keys.sh"

  # Add to cron
  cat <<EOF >>/etc/cron.d/update_ssh_keys_schedule
${keys_update_frequency} $SSH_USER /home/$SSH_USER/update_ssh_authorized_keys.sh >> /var/log/update_ssh_keys.log 2>&1
EOF
  touch /var/log/update_ssh_keys.log
  chown $SSH_USER /var/log/update_ssh_keys.log
  chmod 644 /var/log/update_ssh_keys.log

  echo "Starting cron service..."
  sudo service crond start
}
ssh_authorized_keys_addition
