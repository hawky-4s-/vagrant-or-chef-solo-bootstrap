#!/bin/bash -xe

# commom tmp dir
TMP_DIR_BOOTSTRAP="/tmp/bootstrap"

# get environment variables
OS=$(lsb_release -si)
ARCH=$(uname -m)
VER=$(lsb_release -sr)

# https://www.virtualbox.org/wiki/Linux_Downloads -> latest version http://download.virtualbox.org/virtualbox/LATEST.TXT



# vagrant version and package download url
VAGRANT_VERSION=1.2.2
VAGRANT_RELEASE_UUID=7e400d00a3c5a0fdf2809c8b5001a035415a607b
VAGRANT_RELEASE_URL=http://files.vagrantup.com/packages/$(VAGRANT_RELEASE_UUID)
# necessary packages for this script / vagrant
PACKAGES="git wget virtualbox-4.2 build-essential libxslt-dev libxml2-dev"

# environment specific settings
echo "Detected $(OS)-$(VER)-$(ARCH)"

case $(OS) in
  Ubuntu|LinuxMint|Debian )
    PACKAGE_FORMAT=deb
    PACKAGE_MANAGER=aptitude
  ;;
  Fedora|CentOS )
    PACKAGE_FORMAT=rpm
    PACKAGE_MANAGER=yum
  ;;
  * )
    echo "OS not supported"
    exit 1
  ;;
esac

# install necessary packages
sudo ${PACKAGE_MANAGER} install ${PACKAGES} -y

# install ruby!

# download and install vagrant
VAGRANT_FILE="vagrant_$(VAGRANT_VERSION)_$(ARCH).$(PACKAGE_FORMAT)"
mkdir -p ${TMP_DIR_BOOTSTRAP}
wget $(VAGRANT_RELEASE_URL)/$(VAGRANT_FILE) -O $(TMP_DIR_BOOTSTRAP)/$(VAGRANT_FILE)
sudo dpkg -i $(TMP_DIR_BOOTSTRAP)/$(VAGRANT_FILE)

# install berkshelf, it's vagrant-plugin, foodcritic and bundler for cookbook development
gem install berkshelf
gem install bundler
gem install foodcritic
rbenv rehash
vagrant plugin install vagrant-berkshelf

rm -rf $(TMP_DIR_BOOTSTRAP)
