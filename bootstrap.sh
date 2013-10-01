#!/usr/bin/env bash

if [ -f ./.bootstrap.cfg ]; then
  source .bootstrap.cfg
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SCRIPTS_DIR="scripts"
export BOOTSTRAP_TMP_DIR="/tmp/bootstrap"

if [ -n "${SCRIPTS}" ]; then
  echo "Using custom defined scripts: ${SCRIPTS[@]}"
else
  SCRIPTS=('environment' 'base' 'vagrant') # 'ruby' 'virtualbox' 'vagrant' 'veewee')
  echo "Using default defined scripts: ${SCRIPTS[@]}"
fi

# change to script dir
#cd "$(dirname "$0")"

# create temp dir
mkdir -p "${BOOTSTRAP_TMP_DIR}"

# execute scripts
for script in "${SCRIPTS[@]}";
do
  source "${SCRIPTS_DIR}/${script}.sh";
done

# cleanup
rm -rf "${BOOTSTRAP_TMP_DIR}"


#gem install knife-solo
#gem install knife-solo_data_bag