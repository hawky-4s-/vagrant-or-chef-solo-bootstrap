#!/usr/bin/env sh
set -x

# check if chef-solo is installed

if [ -a "/var/lib/gems/1.9.1/bin/chef-solo" ]; then
  export CHEF_PATH=/var/lib/gems/1.9.1/bin
elif [ -a "/usr/local/bin/chef-solo" ]; then
  export CHEF_PATH=/usr/local/bin
elif [ -a "/usr/bin/chef-solo" ]; then
  export CHEF_PATH=/usr/bin
elif [ -a "${HOME}/.rbenv/shims/chef-solo" ]; then
  export CHEF_PATH=${HOME}/.rbenv/shims
else
  echo "Chef-solo not found!"
fi

echo "Found chef on path: '${CHEF_PATH}'."

# This runs as root on the server
CHEF_BINARY=${CHEF_PATH}/chef-solo

# Are we on a vanilla system?
if [ ! -z '${CHEF_PATH}' ]; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    aptitude update &&
    aptitude safe-upgrade -fy
    apittude install curl -yq
    #apt-get -o Dpkg::Options::="--force-confnew" \
    #    --force-yes -fuy dist-upgrade &&

    # install omnibus chef
    curl -L https://www.opscode.com/chef/install.sh | sudo bash

fi