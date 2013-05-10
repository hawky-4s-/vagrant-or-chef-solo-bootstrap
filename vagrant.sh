#!/bin/bash -xe

# vagrant version and package download url
VAGRANT_VERSION=1.2.2
VAGRANT_RELEASE_UUID="7e400d00a3c5a0fdf2809c8b5001a035415a607b"
VAGRANT_RELEASE_URL="http://files.vagrantup.com/packages/${VAGRANT_RELEASE_UUID}"

VAGRANT_FILE="vagrant_${VAGRANT_VERSION}_${ARCH}.${PACKAGE_FORMAT}"
mkdir -p ${TMP_DIR_BOOTSTRAP}
wget ${VAGRANT_RELEASE_URL}/${VAGRANT_FILE} -O ${TMP_DIR_BOOTSTRAP}/${VAGRANT_FILE}

if [ ${PACKAGE_FORMAT} = "deb" ]; then
    sudo dpkg -i ${TMP_DIR_BOOTSTRAP}/${VAGRANT_FILE}
elif [ ${PACKAGE_FORMAT} = "rpm" ]; then
    sudo ${PACKAGE_MANAGER} --nogpgcheck localinstall ${TMP_DIR_BOOTSTRAP}/${VAGRANT_FILE} -y
else
    echo "Unable to install vagrant, because package format is unknown."
    exit 1
fi

# install berkshelf, it's vagrant-plugin, foodcritic and bundler
gem install berkshelf
rbenv rehash
gem install bundler
rbenv rehash
gem install foodcritic
rbenv rehash
vagrant plugin install vagrant-berkshelf