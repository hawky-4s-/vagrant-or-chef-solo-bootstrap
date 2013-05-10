#!/bin/bash
 
# Usage: ./deploy.sh [host]
 
host="${1:-aaron@192.168.1.39}"
 
# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null

# Generate new ssh key for increased security
#ssh-keygen -t rsa -f /home/some_user/.ssh/id_rsa -P "123"

# Upload our ssh key so we can stop typing the remote password:
if [ -e "$HOME/.ssh/id_rsa.pub" ]; then
  cat "$HOME/.ssh/id_rsa.pub" | ssh -o 'StrictHostKeyChecking no' "$host" 'mkdir -m 700 -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
fi

if [ "$host" =~ "root" ]; then
    tar cjh . | ssh -o 'StrictHostKeyChecking no' "$host" '
    rm -rf /tmp/chef &&
    mkdir /tmp/chef &&
    cd /tmp/chef &&
    tar xj &&
    bash install.sh'
else
    # Use this version if you don't ssh in as root (e.g. on EC-2):
    tar cj . | ssh -o 'StrictHostKeyChecking no' "$host" '
    sudo rm -rf ~/chef &&
    mkdir ~/chef &&
    cd ~/chef &&
    tar xj &&
    sudo bash install.sh'
fi
