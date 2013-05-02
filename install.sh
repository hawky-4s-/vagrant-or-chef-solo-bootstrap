#!/bin/bash
 
# This runs as root on the server
 
#chef_binary=/usr/local/bin/chef-solo
chef_binary=~/.rbenv/shims/chef-solo
 
# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    aptitude update &&
    aptitude safe-upgrade -fy
    #apt-get -o Dpkg::Options::="--force-confnew" \
    #    --force-yes -fuy dist-upgrade &&


    # install omnibus chef - curl -L https://www.opscode.com/chef/install.sh | sudo bash


    # Install Ruby and Chef

    aptitude install zlib1g-dev openssl libopenssl-ruby1.9.1 libssl-dev libruby1.9.1 libreadline-dev git-core make make-doc -y

    cd ~
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    exec $SHELL # Restart the shell
    mkdir -p ~/.rbenv/plugins
    cd ~/.rbenv/plugins
    git clone git://github.com/sstephenson/ruby-build.git
    git clone git://github.com/sstephenson/rbenv-gem-rehash.git
    rbenv install 1.9.3-p362
    rbenv rehash
    rbenv global 1.9.3-p362

    gem update --no-rdoc --no-ri
    gem install ohai chef --no-rdoc --no-ri

    # http://berkshelf.com/
    gem install berkshelf

fi &&
 
"$chef_binary" -c solo.rb -j solo.json
