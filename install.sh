#!/usr/bin/env sh

if [ -a /var/lib/gems/1.9.1/bin/chef-solo ]; then
   export CHEF_PATH=/var/lib/gems/1.9.1/bin
fi
if [ -a /usr/local/bin/chef-solo ]; then
   export CHEF_PATH=/usr/local/bin
fi
if [ -a "${HOME}/.rbenv/shims/chef-solo" ]; then
    export CHEF_PATH=${HOME}/.rbenv/shims
fi

# This runs as root on the server
CHEF_BINARY=${CHEF_PATH}/chef-solo
 
# Are we on a vanilla system?
if ! test -f "${CHEF_BINARY}"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    aptitude update &&
    aptitude safe-upgrade -fy
    #apt-get -o Dpkg::Options::="--force-confnew" \
    #    --force-yes -fuy dist-upgrade &&


    # install omnibus chef - curl -L https://www.opscode.com/chef/install.sh | sudo bash


    # Install Ruby and Chef

    aptitude install zlib1g-dev openssl libopenssl-ruby1.9.1 libssl-dev libruby1.9.1 libreadline-dev git-core make make-doc -y



    git clone git://github.com/sstephenson/rbenv-gem-rehash.git
    rbenv install 1.9.3-p362
    rbenv rehash
    rbenv global 1.9.3-p362

    gem update --no-rdoc --no-ri
    gem install ohai chef --no-rdoc --no-ri

fi &&
 
"${CHEF_BINARY}" -c solo.rb -j solo.json
