#!/usr/bin/env bash

if [ -f ~/.bootstrap_params ]; then
  source .bootstrap_params
fi

SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
SCRIPTS_DIR="scripts"
export BOOTSTRAP_TMP_DIR="/tmp/bootstrap"

SCRIPTS=('environment.sh' 'base.sh') # 'ruby.sh' 'virtualbox.sh' 'vagrant.sh' 'veewee.sh')

# change to script dir
cd $(dirname "$0")

# create temp dir
mkdir -p ${BOOTSTRAP_TMP_DIR}

# execute scripts
for script in "${SCRIPTS[@]}";
do
    source "${SCRIPTS_DIR}/${script}";
done

# cleanup
rm -rf ${BOOTSTRAP_TMP_DIR}


#gem install knife-solo
#gem install knife-solo_data_bag