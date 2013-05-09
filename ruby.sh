#!/bin/bash -xe

RUBY_VERSION="1.9.3-p392"
RBENV_HOME="${HOME}/.rbenv"
RUBY_BUILD_HOME="${RBENV_HOME}/plugins/ruby-build"


#sudo apt-get -y install build-essential zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev


# install rbenv
if [ -d "${RBENV_HOME}" ];
then
    echo "${RBENV_HOME} already exists."
    # pull new version?
else
    cd && git clone git@github.com:sstephenson/rbenv.git ${RBENV_HOME}
fi

# Add rbenv to your PATH
# NOTE: rbenv is *NOT* compatible with rvm, so you'll need to
# remove rvm from your profile if it's present. (This is because
# rvm overrides the `gem` command.)
if [ -f "${HOME}/.bash_profile" ];
then
    BASH_SETTINGS=${HOME}/".bash_profile"
fi
if [ -f "${HOME}/.bashrc" ];
then
    BASH_SETTINGS=${HOME}/".bashrc"
fi
echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"' >> ${BASH_SETTINGS}
echo 'eval "$(rbenv init -)"' >> ${BASH_SETTINGS}
#exec $SHELL

# Install Ruby versions into ~/.rbenv/versions
# (ruby-build is a convenient way to do this)
if [ -d "${RUBY_BUILD_HOME}" ];
then
    cd ${RUBY_BUILD_HOME} && git pull
else
    cd && git clone https://github.com/sstephenson/ruby-build.git ${RUBY_BUILD_HOME}
fi

# install specified ruby version
if [ -d "${RBENV_HOME}/versions/${RUBY_VERSION}" ];
then
    echo "ruby version ${RUBY_VERSION} already installed."
else
    rbenv install ${RUBY_VERSION}
fi

# Install shims for all Ruby binaries
rbenv rehash

# Set a default Ruby version
rbenv global ${RUBY_VERSION}

ACTUAL_RUBY_VERSION=`ruby --version`
if [ ${ACTUAL_RUBY_VERSION} =~ ${RUBY_VERSION} ];
then
    echo "Success"
    exit 0
else
    echo "current ruby version: ${ACTUAL_RUBY_VERSION} isn't equals specified ruby version: ${RUBY_VERSION}"
    exit 1
fi