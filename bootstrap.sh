#!/bin/bash -xe

if [ -f .bootstrap_params ]; then
  source .bootstrap_params
fi

# commom tmp dir
export TMP_DIR_BOOTSTRAP="/tmp/bootstrap"

source common.sh

# install ruby
source ruby.sh

# install virtualbox
source virtualbox.sh

# install vagrant
source vagrant.sh

# install veewee
source veewee.sh

rm -rf ${TMP_DIR_BOOTSTRAP}
