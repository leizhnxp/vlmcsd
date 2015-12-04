#!/bin/bash
#
# Install a VLMCSD service for CentOS/RedHat
#
# Author: Wind4 (puxiaping@gmail.com)
# Date:   November 30, 2015
#

check_result() {
  if [ $1 -ne 0 ]; then
    echo "Error: $2" >&2
    exit $1
  fi
}

if [ "x$(id -u)" != 'x0' ]; then
  echo 'Error: This script can only be executed by root'
  exit 1
fi

if [ -f '/etc/init.d/vlmcsd' ]; then
  echo 'VLMCSD service has been installed.'
  exit 1
fi

if [ ! -f '/usr/bin/wget' ]; then
  echo 'Installing wget ...'
  yum install -y -q wget
  check_result $? "Can't install wget."
  echo 'Install wget succeed.'
fi

echo 'Downloading vlmcsd ...'
wget -q https://wind4.github.io/vlmcsd/binaries/Linux/intel/static/vlmcsd-x86-musl-static -O /usr/bin/vlmcsd
check_result $? 'Download vlmcsd failed.'

echo 'Downloading startup script ...'
wget -q https://wind4.github.io/vlmcsd/scripts/init.d/vlmcsd-rhel -O /etc/init.d/vlmcsd
check_result $? 'Download startup script failed.'

echo 'Configuring deamon ...'
chmod 755 /usr/bin/vlmcsd
chmod 755 /etc/init.d/vlmcsd
chkconfig --add vlmcsd
chkconfig vlmcsd on
service vlmcsd start
check_result $? 'Installation failed.'
echo 'Installed successfully.'