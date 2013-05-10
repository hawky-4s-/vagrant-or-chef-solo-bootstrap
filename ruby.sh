#!/bin/bash -xe

export RUBY_VERSION="1.9.3-p392"
export RBENV_HOME="${HOME}/.rbenv"
export RBENV_PLUGINS_HOME="${RBENV_HOME}/plugins"
export RUBY_BUILD_HOME="${RBENV_PLUGINS_HOME}/ruby-build"

# install plugins from array values and a loop?
# ruby-build, rbenv-gem-rehash, rbenv-default-gems


#sudo apt-get -y install build-essential zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev


# install rbenv
if [ -d "${RBENV_HOME}" ]; then
    echo "${RBENV_HOME} already exists."
    # pull new version?
else
    cd && git clone https://github.com/sstephenson/rbenv.git ${RBENV_HOME}
fi

# Add rbenv to your PATH
# NOTE: rbenv is *NOT* compatible with rvm, so you'll need to
# remove rvm from your profile if it's present. (This is because
# rvm overrides the `gem` command.)
echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"' >> ${BASH_SETTINGS}
echo 'eval "$(rbenv init -)"' >> ${BASH_SETTINGS}
source ${BASH_SETTINGS}

# Install Ruby versions into ~/.rbenv/versions
# (ruby-build is a convenient way to do this)
if [ -d "${RBENV_PLUGINS_HOME}/ruby-build" ]; then
    (cd ${RBENV_PLUGINS_HOME}/ruby-build && git pull)
else
    cd && git clone https://github.com/sstephenson/ruby-build.git ${RBENV_PLUGINS_HOME}/ruby-build
fi

# install specified ruby version
if [ -d "${RBENV_HOME}/versions/${RUBY_VERSION}" ]; then
    echo "ruby version ${RUBY_VERSION} already installed."
else
    rbenv install ${RUBY_VERSION}
fi

# Install shims for all Ruby binaries
rbenv rehash

# Set a default Ruby version
rbenv global ${RUBY_VERSION}
rbenv rehash

if [ -d "${RBENV_PLUGINS_HOME}/rbenv-gem-rehash" ]; then
    (cd "${RBENV_PLUGINS_HOME}/rbenv-gem-rehash" && git pull)
else
    cd && git clone https://github.com/sstephenson/rbenv-gem-rehash.git ${RBENV_PLUGINS_HOME}/rbenv-gem-rehash
fi

rbenv-gem-rehash



# list in file one at a line -> bundler, berkshelf, foodcritic,chef,ohai  in  ~/.rbenv/default-gems

## how to check version?
#ACTUAL_RUBY_VERSION=$(ruby --version)
#if [ "${ACTUAL_RUBY_VERSION}" =~ "${RUBY_VERSION}" ]; then
#    echo "Success"
#    exit 0
#else
#    echo "current ruby version: ${ACTUAL_RUBY_VERSION} isn't equals specified ruby version: ${RUBY_VERSION}"
#    exit 1
#fi