#!/bin/bash -xe

# necessary packages for this script / vagrant
APT_PACKAGES="virtualbox"
YUM_PACKAGES="VirtualBox-4.2"

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
sudo ${PACKAGE_MANAGER} install ${PACKAGES} -y

sudo usermod -a -G vboxusers ${USER}



#VBOX_LATEST_VERSION=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)
#http://download.virtualbox.org/virtualbox/rpm/



#!/usr/bin/env sh
#
#INSTALL_UBUNTU_DISTRO=${UBUNTU_VERSION-lucid}
#VBOX_LATEST_VERSION=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)
#
#sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian ${INSTALL_UBUNTU_DISTRO} contrib" > /etc/apt/sources.list.d/virtualbox.list'
#wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
#sudo apt-get update ; sudo apt-get install dkms virtualbox-${VBOX_LATEST_VERSION}
#
#wget -c http://download.virtualbox.org/virtualbox/${VBOX_LATEST_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_LATEST_VERSION}.vbox-extpack -O /tmp/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_LATEST_VERSION}.vbox-extpack
#VBoxManage extpack uninstall "Oracle VM VirtualBox Extension Pack"
#VBoxManage extpack cleanup
#VBoxManage extpack install /tmp/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_LATEST_VERSION}.vbox-extpack
#
#usermod -a -G vboxusers nodemanager


#http://www.if-not-true-then-false.com/2010/install-virtualbox-with-yum-on-fedora-centos-red-hat-rhel/
#cd /etc/yum.repos.d/
#
### Fedora 18/17/16/15/14/13/12 users
#wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
#
### CentOS 6.4/6.3/6.2/6.1/6/5.9 and Red Hat (RHEL) 6.4/6.3/6.2/6.1/6/5.9 users
#wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo



#/etc/init.d/vboxdrv setup
### OR ##
#service vboxdrv setup