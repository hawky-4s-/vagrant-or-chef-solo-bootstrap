#!/usr/bin/env sh -xe

if [ -f .bootstrap_params ]; then
  source .bootstrap_params
fi

SCRIPTS_DIR="scripts"
export BOOTSTRAP_TMP_DIR="/tmp/bootstrap"

# create temp dir
mkdir -p ${SCRIPTS_DIR}

# install common stuff
source ${SCRIPTS_DIR}/common.sh

# install ruby
source ${SCRIPTS_DIR}/ruby.sh

# install virtualbox
source ${SCRIPTS_DIR}/virtualbox.sh

# install vagrant
source ${SCRIPTS_DIR}/vagrant.sh

# install veewee
source ${SCRIPTS_DIR}/veewee.sh

# cleanup
rm -rf ${BOOTSTRAP_TMP_DIR}
