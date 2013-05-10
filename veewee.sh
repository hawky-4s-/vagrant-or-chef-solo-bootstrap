#!/bin/bash

VEEWEE_INSTALL_DIR="veewee"

# https://github.com/Jimdo/veewee-definitions
# https://github.com/jedi4ever/veewee/blob/master/doc/vagrant.md

# install specified ruby version
if [ -d "${RBENV_HOME}/versions/${RUBY_VERSION}" ];
then
    echo "ruby version ${RUBY_VERSION} already installed."
else
    rbenv install ${RUBY_VERSION}
fi

rbenv rehash

git clone https://github.com/jedi4ever/veewee.git ${VEEWEE_INSTALL_DIR} && cd ${VEEWEE_INSTALL_DIR}

# install local ruby version for veewee
rbenv local ${RUBY_VERSION}
rbenv rehash
gem install bundler
rbenv rehash
bundle install
rbenv rehash

echo "alias veewee='bundle exec veewee'" >> ${BASH_SETTINGS}
source ${BASH_SETTINGS}

# bundle exec veewee
# vagrant basebox