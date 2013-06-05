#!/usr/bin/env sh -xe

if [ -f .bootstrap_params ]; then
  source .bootstrap_params
fi

VBOX_LATEST_VERSION=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)

# prerequisites for virtualbox
VIRTUALBOX_PREREQUISITES_APT="build-essential dkms"
VIRTUALBOX_PREREQUISITES_YUM="binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-PAE-devel dkms"

VIRTUALBOX_PACKAGE_APT="virtualbox-${VBOX_LATEST_VERSION}"
VIRTUALBOX_PACKAGE_YUM="VirtualBox-${VBOX_LATEST_VERSION}"


# Install prerequisites
case ${OS} in
  Ubuntu )
    PREREQUISITES=${VIRTUALBOX_PREREQUISITES_APT}
  ;;
  Fedora | CentOS )
    PREREQUISITES=${VIRTUALBOX_PREREQUISITES_YUM}
  ;;
  * )
    echo "OS not supported"
    exit 1
  ;;
esac

sudo ${ENV_PACKAGE_MANAGER} update && sudo ${ENV_PACKAGE_MANAGER} upgrade -y
sudo ${ENV_PACKAGE_MANAGER} install ${PREREQUISITES} -y


# Default to package install
if [ -z "${ENV_VIRTUALBOX_INSTALLMETHOD}" ]; then
  export ENV_VIRTUALBOX_INSTALLMETHOD="package"
fi

# Installing virtualbox
case ${ENV_VIRTUALBOX_INSTALLMETHOD} in
  virtualbox-repository )
    # install virtualbox from virtualbox.org repository
    case ${OS} in
      Ubuntu )
        VIRTUALBOX_PACKAGE=${VIRTUALBOX_PACKAGE_APT}
        sudo 'echo "deb http://download.virtualbox.org/virtualbox/debian ${INSTALL_UBUNTU_DISTRO} contrib" > /etc/apt/sources.list.d/virtualbox.list'
        wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
      ;;
      Fedora )
        VIRTUALBOX_PACKAGE=${VIRTUALBOX_PACKAGE_YUM}
        sudo wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo
      ;;
      CentOS )
        VIRTUALBOX_PACKAGE=${VIRTUALBOX_PACKAGE_YUM}
        sudo wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo
      ;;
      * )
        echo "OS not supported"
        exit 1
      ;;
    esac

    sudo ${ENV_PACKAGE_MANAGER} update && sudo ${ENV_PACKAGE_MANAGER} upgrade -y
    sudo ${ENV_PACKAGE_MANAGER} install ${VIRTUALBOX_PACKAGE} -y
  ;;
  download )
    echo "not yet availabe"
    exit 1
  ;;
  package )
    # install virtualbox package maintained by linux distribution
    case ${OS} in
      Ubuntu )
        PACKAGES=${VIRTUALBOX_PREREQUISITES_APT}
      ;;
      Fedora )
        PACKAGES=${VIRTUALBOX_PREREQUISITES_YUM}
      ;;
      * )
        echo "OS not supported."
        exit 1
      ;;
    esac

    sudo ${ENV_PACKAGE_MANAGER} update && sudo ${ENV_PACKAGE_MANAGER} upgrade -y
    sudo ${ENV_PACKAGE_MANAGER} install ${PACKAGES} -y

    sudo usermod -a -G vboxusers ${USER}
  ;;
  * )
    echo "Install method for virtualbox not supported."
    exit 1
  ;;
esac


#VBOX_LATEST_VERSION=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)
# http://download.virtualbox.org/virtualbox/rpm/
# http://download.virtualbox.org/virtualbox/debian/
# http://download.virtualbox.org/virtualbox/${VOB_LATEST_VERSION}/



#
#INSTALL_UBUNTU_DISTRO=${UBUNTU_VERSION-lucid}
#VBOX_LATEST_VERSION=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)
#
#wget -c http://download.virtualbox.org/virtualbox/${VBOX_LATEST_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_LATEST_VERSION}.vbox-extpack -O /tmp/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_LATEST_VERSION}.vbox-extpack
#VBoxManage extpack uninstall "Oracle VM VirtualBox Extension Pack"
#VBoxManage extpack cleanup
#VBoxManage extpack install /tmp/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_LATEST_VERSION}.vbox-extpack
#


#http://www.if-not-true-then-false.com/2010/install-virtualbox-with-yum-on-fedora-centos-red-hat-rhel/

#/etc/init.d/vboxdrv setup
### OR ##
#service vboxdrv setup