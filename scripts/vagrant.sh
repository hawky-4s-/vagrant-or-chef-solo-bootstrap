#!/usr/bin/env bash
# requires:
#   - ruby
set -x

if [[ $_ != $0 ]]; then
  echo "Script is being sourced"
  SCRIPT_DIR=$(dirname "${BASH_SOURCE}")
else
  echo "Script is being run"
  SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
fi

if [ ! -n "${ENV_BASH_SETTINGS}" ]; then
  source ${SCRIPT_DIR}/environment.sh
fi

# vagrant version and package download url
VAGRANT_GITHUB="mitchellh/vagrant"
VAGRANT_VERSION=$(curl -s https://api.github.com/repos/${VAGRANT_GITHUB}/git/refs/tags \
| ruby -rjson -e '
  j = JSON.parse(STDIN.read);
  version = j.map { |t| t["ref"].split("/").last }.sort.last
  puts version[1, version.length]
')
VAGRANT_RELEASE_UUID=$(curl -s https://api.github.com/repos/${VAGRANT_GITHUB}/git/refs/tags \
| ruby -rjson -e '
  j = JSON.parse(STDIN.read);
  version = j.map { |t| t["ref"].split("/").last }.sort.last
  commit = j.find { |t| t["ref"].include? version }
  puts commit["object"]["sha"]
')
VAGRANT_RELEASE_URL="http://files.vagrantup.com/packages/${VAGRANT_RELEASE_UUID}"

VAGRANT_FILE="vagrant_${VAGRANT_VERSION}_${ENV_ARCH}.${ENV_PACKAGE_FORMAT}"
mkdir -p "${BOOTSTRAP_TMP_DIR}"
wget ${VAGRANT_RELEASE_URL}/${VAGRANT_FILE} -O ${BOOTSTRAP_TMP_DIR}/${VAGRANT_FILE}

if [ "${ENV_PACKAGE_FORMAT}" = "deb" ]; then
    sudo dpkg -i ${BOOTSTRAP_TMP_DIR}/${VAGRANT_FILE}
elif [ "${ENV_PACKAGE_FORMAT}" = "rpm" ]; then
    sudo ${ENV_PACKAGE_MANAGER} --nogpgcheck localinstall ${BOOTSTRAP_TMP_DIR}/${VAGRANT_FILE} -y
else
    echo "Unable to install vagrant, because package format is unknown."
    exit 1
fi

if [ ! -n "${VAGRANT_PLUGINS}" ]; then
  VAGRANT_PLUGINS=('berkshelf' 'omnibus' 'cachier') #vbguest
fi

for plugin in "${VAGRANT_PLUGINS[@]}"; do
  vagrant plugin install vagrant-${plugin}
done