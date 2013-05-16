#!/usr/bin/env sh

export RUBY_MAIN_VERSION="1.9.3"
export RUBY_PATCH_VERSION="p392"
export RUBY_VERSION="$[RUBY_MAIN_VERSION}-$[RUBY_PATCH_VERSION}"

# install plugins from array values and a loop?
# RBENV_INSTALLPLUGINS=("ruby-build" "rbenv-gem-rehash" "rbenv-default-gems")

# RBENV_DEFAULTGEMS=("bundler" "berkshelf" "foodcritic")  bundler, berkshelf, foodcritic,chef,ohai  in  ~/.rbenv/default-gems
# for i in "${RBENV_DEFAULTGEMS[@]}"; do echo $i >> ${RBENV_HOME}/default-gems

#sudo apt-get -y install build-essential zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev

case "$(ruby -v)" in
    *${RUBY_MAIN_VERSION}* )
        echo "ruby with correct version already exists."
    ;;
    * )
        echo "no"
    ;;
esac