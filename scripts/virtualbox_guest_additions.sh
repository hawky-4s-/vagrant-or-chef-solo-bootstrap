#!/usr/bin/env sh

if [ -f .bootstrap_params ]; then
  source .bootstrap_params
fi

VBOX_LATEST_VERSION=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)

sudo ${ENV_PACKAGE_MANAGER} install dkms build-essential -y
#http://download.virtualbox.org/virtualbox/4.2.12/

wget -c http://download.virtualbox.org/virtualbox/${VBOX_LATEST_VERSION}/VBoxGuestAdditions_${VBOX_LATEST_VERSION}.iso -O /tmp/VBoxGuestAdditions_${VBOX_LATEST_VERSION}.iso
sudo mkdir -p /media/guestadditions ; sudo mount -o loop /tmp/VBoxGuestAdditions_${VBOX_LATEST_VERSION}.iso /media/guestadditions
sudo /media/guestadditions/VBoxLinuxAdditions.run
sudo umount /media/guestadditions && sudo rm -rf /tmp/VBoxGuestAdditions_${VBOX_VERSION}.iso /media/guestadditions

echo 'You may safely ignore the message that reads: "Could not find the X.Org or XFree86 Window System."'