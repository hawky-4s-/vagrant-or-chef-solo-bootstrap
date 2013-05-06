#!/bin/bash

# commom tmp dir
TMP_DIR_BOOTSTRAP="/tmp/bootstrap"

# get environment variables
OS=$(lsb_release -si)
ARCH=$(uname -m)
VER=$(lsb_release -sr)

# vagrant version and package download url
VAGRANT_VERSION=1.2.2
VAGRANT_RELEASE_UUID=7e400d00a3c5a0fdf2809c8b5001a035415a607b
VAGRANT_RELEASE_URL=http://files.vagrantup.com/packages/$(VAGRANT_RELEASE_UUID)/vagrant_

# environment specific settings
echo Detected $(OS)-$(VER)-$(ARCH)

# install virtualbox and vagrant if specified
case $OS in
  Ubuntu )
    PACKAGE_FORMAT=deb
    sudo apitude install VirtualBox -y
  ;;
  Fedora )
    PACKAGE_FORMAT=rpm
    sudo yum install VirtualBox -y
  ;;
  * )
  ;;
esac


# download and install vagrant
wget $(VAGRANT_RELEASE_URL)$(ARCH).$(PACKAGE_FORMAT) -O $(TMP_DIR_BOOTSTRAP)

# install vagrant


# install vagrant's berkshelf plugin
vagrant plugin install vagrant-berkshelf

rm -rf $(TMP_DIR_BOOTSTRAP)
