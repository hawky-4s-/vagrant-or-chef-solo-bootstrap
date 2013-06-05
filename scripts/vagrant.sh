#!/usr/bin/env sh -xe

if [ -f .bootstrap_params ]; then
  source .bootstrap_params
fi

# vagrant version and package download url
VAGRANT_VERSION=1.2.2
VAGRANT_RELEASE_UUID="7e400d00a3c5a0fdf2809c8b5001a035415a607b"
VAGRANT_RELEASE_URL="http://files.vagrantup.com/packages/${VAGRANT_RELEASE_UUID}"

VAGRANT_FILE="vagrant_${VAGRANT_VERSION}_${ENV_ARCH}.${ENV_PACKAGE_FORMAT}"
mkdir -p ${TMP_DIR_BOOTSTRAP}
wget ${VAGRANT_RELEASE_URL}/${VAGRANT_FILE} -O ${TMP_DIR_BOOTSTRAP}/${VAGRANT_FILE}

if [ ${ENV_PACKAGE_FORMAT} = "deb" ]; then
    sudo dpkg -i ${TMP_DIR_BOOTSTRAP}/${VAGRANT_FILE}
elif [ ${ENV_PACKAGE_FORMAT} = "rpm" ]; then
    sudo ${ENV_PACKAGE_MANAGER} --nogpgcheck localinstall ${TMP_DIR_BOOTSTRAP}/${VAGRANT_FILE} -y
else
    echo "Unable to install vagrant, because package format is unknown."
    exit 1
fi

# install berkshelf, it's vagrant-plugin, foodcritic and bundler
# where to install berkshelf etc best?
gem install berkshelf
gem install bundler
gem install foodcritic
vagrant plugin install vagrant-berkshelf

vagrant plugin install vagrant-vbguest