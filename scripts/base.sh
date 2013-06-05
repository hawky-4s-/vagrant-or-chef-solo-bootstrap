#!/usr/bin/env sh

if [ -f .bootstrap_params ]; then
  source .bootstrap_params
fi

# necessary packages for this script / vagrant
APT_PACKAGES="git wget build-essential libxslt-dev libxml2-dev zlib1g-dev openssl"
YUM_PACKAGES="git wget binutils gcc gcc-c++ make patch kernel-headers kernel-devel glibc-headers glibc-devel libxslt-devel libxml2-devel zlib-devel openssl-devel openssl"

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

#sudo ${ENV_PACKAGE_MANAGER} update && sudo ${ENV_PACKAGE_MANAGER} upgrade -y
# install necessary packages
#sudo ${ENV_PACKAGE_MANAGER} install ${PACKAGES} -y