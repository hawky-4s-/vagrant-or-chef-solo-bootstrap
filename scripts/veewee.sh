#!/usr/bin/env sh

VEEWEE_INSTALL_DIR="veewee"

# https://github.com/Jimdo/veewee-definitions
# https://github.com/jedi4ever/veewee/blob/master/doc/vagrant.md

# install specified ruby version
if [ -d "${ENV_RBENV_HOME}/versions/${ENV_RUBY_VERSION}" ];
then
    echo "ruby version ${ENV_RUBY_VERSION} already installed."
else
    rbenv install ${ENV_RUBY_VERSION}
fi

rbenv rehash

git clone https://github.com/jedi4ever/veewee.git ${VEEWEE_INSTALL_DIR} && cd ${VEEWEE_INSTALL_DIR}

# install local ruby version for veewee
rbenv local ${ENV_RUBY_VERSION}
rbenv rehash
gem install bundler
rbenv rehash
bundle install
rbenv rehash

echo "alias veewee='bundle exec veewee'" >> ${ENV_BASH_SETTINGS}
source ${ENV_BASH_SETTINGS}

# bundle exec veewee
# vagrant basebox