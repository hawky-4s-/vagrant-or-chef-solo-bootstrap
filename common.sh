#!/bin/bash

# get system environment variables
export OS=$(lsb_release -si)
export ARCH=$(uname -m)
export VERSION=$(lsb_release -sr)
export CODENAME=$(lsb_release -sc)

# environment specific settings
echo "Detected OS: ${OS} ${VERSION} (${CODENAME}) ${ARCH}"

case ${OS} in
  # Ubuntu|LinuxMint|Debian )
  Ubuntu )
    PACKAGE_FORMAT=deb
    PACKAGE_MANAGER=aptitude
  ;;
  # Fedora|CentOS )
  Fedora )
    PACKAGE_FORMAT=rpm
    PACKAGE_MANAGER=yum
  ;;
  * )
    echo "OS not supported"
    exit 1
  ;;
esac

export PACKAGE_FORMAT
export PACKAGE_MANAGER

# file to create alias
if [ -f "${HOME}/.profile" ]; then
    BASH_SETTINGS=${HOME}/".profile"
elif [ -f "${HOME}/.bash_profile" ]; then
    BASH_SETTINGS=${HOME}/".bash_profile"
elif [ -f "${HOME}/.bashrc" ]; then
    BASH_SETTINGS=${HOME}/".bashrc"
else
    echo "Unable to locate correct bash settings file."
    exit 1;
fi

export BASH_SETTINGS