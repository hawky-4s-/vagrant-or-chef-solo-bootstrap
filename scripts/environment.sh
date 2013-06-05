#!/usr/bin/env bash

echo "cd $(dirname "$0")"

. ./functions.sh

exists "aptitude"
exists "apt-get"
exists "yum"
exists "uname"
exists "lsb_release"

if [ -f .bootstrap_params ]; then
  source .bootstrap_params
fi

# get system environment variables
export ENV_OS=$(lsb_release -si)
export ENV_ARCH=$(uname -m)
export ENV_VERSION=$(lsb_release -sr)
export ENV_CODENAME=$(lsb_release -sc)

# environment specific settings
echo "Detected OS: ${ENV_OS} ${ENV_VERSION} (${ENV_CODENAME}) ${ENV_ARCH}"

case ${ENV_OS} in
  # Ubuntu|LinuxMint|Debian )
  Ubuntu )
    ENV_PACKAGE_FORMAT=deb
    ENV_PACKAGE_MANAGER=aptitude
  ;;
  # Fedora|CentOS )
  Fedora )
    ENV_PACKAGE_FORMAT=rpm
    ENV_PACKAGE_MANAGER=yum
  ;;
  * )
    echo "OS not supported"
    exit 1
  ;;
esac

export ENV_PACKAGE_FORMAT
export ENV_PACKAGE_MANAGER

# file to create alias
if [ -f "${HOME}/.profile" ]; then
    ENV_BASH_SETTINGS=${HOME}/".profile"
elif [ -f "${HOME}/.bash_profile" ]; then
    ENV_BASH_SETTINGS=${HOME}/".bash_profile"
elif [ -f "${HOME}/.bashrc" ]; then
    ENV_BASH_SETTINGS=${HOME}/".bashrc"
else
    echo "Unable to locate correct bash settings file."
    exit 1;
fi

echo "Using ${ENV_BASH_SETTINGS} as file to store bash settings."

export ENV_BASH_SETTINGS