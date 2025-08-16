#!/usr/bin/env sh

useradd -m -s /bin/bash $SSH_USER
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
usermod -aG sudo $SSH_USER
echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/init-users

# SSHD config
echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/my_sshd.conf
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/my_sshd.conf
echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config.d/my_sshd.conf

# Ensure SSH host keys exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
fi

exec "$@"
