#!/bin/bash

# necessary packages for this script / vagrant
APT_PACKAGES="git wget build-essential libxslt-dev libxml2-dev zlib1g-dev openssl dkms"
YUM_PACKAGES="git wget binutils gcc gcc-c++ make patch kernel-headers kernel-devel glibc-headers glibc-devel libxslt-devel libxml2-devel zlib-devel openssl-devel openssl dkms"

case ${OS} in
  Ubuntu )
    PACKAGES=${APT_PACKAGES}
  ;;
  Fedora )
    PACKAGES=${YUM_PACKAGES}
  ;;
  * )
    echo "OS not supported"
    exit 1
  ;;
esac

sudo ${PACKAGE_MANAGER} update && sudo ${PACKAGE_MANAGER} upgrade -y
# install necessary packages
sudo ${PACKAGE_MANAGER} install ${PACKAGES} -y