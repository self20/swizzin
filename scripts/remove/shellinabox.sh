#!/bin/bash 
# Swizzin :: Shellinabox uninstaller
# Author: liara
#
# Copyright (C) 2017 Swizzin
# Licensed under GNU General Public License v3.0 GPL-3
#################################################################################
systemctl stop shellinabox
systemctl disable shellinabox

apt-get -y purge Shellinabox

rm -rf /etc/systemd/system/shellinabox.service
rm -rf /install/.shellinabox.lock
rm -rf /etc/nginx/apps/shell.conf