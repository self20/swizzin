#!/bin/bash
#
# [Quick Box :: Install Sonarr-NzbDrone package]
#
# GITHUB REPOS
# GitHub _ packages  :   https://github.com/QuickBox/quickbox_packages
# LOCAL REPOS
# Local _ packages   :   /etc/QuickBox/packages
# Author             :   QuickBox.IO | JMSolo
# URL                :   https://quickbox.io
#
# QuickBox Copyright (C) 2016
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
#################################################################################

function _installSonarrintro() {
  echo "Sonarr will now be installed." >>"${OUTTO}" 2>&1;
  echo "This process may take up to 2 minutes." >>"${OUTTO}" 2>&1;
  echo "Please wait until install is completed." >>"${OUTTO}" 2>&1;
  # output to box
  echo "Sonarr will now be installed."
  echo "This process may take up to 2 minutes."
  echo "Please wait until install is completed."
  echo
  sleep 5
}

function _installSonarr1() {
  if [[ ! -f /etc/apt/sources.list.d/mono-xamarin.list ]]; then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF >/dev/null 2>&1
    echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list >/dev/null 2>&1
    echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list >/dev/null 2>&1
    echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list >/dev/null 2>&1
  fi
}

function _installSonarr2() {
  sudo apt-get install apt-transport-https -y >/dev/null 2>&1
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC >/dev/null 2>&1
  echo "deb https://apt.sonarr.tv/ master main" | sudo tee -a /etc/apt/sources.list.d/sonarr.list >/dev/null 2>&1
}

function _installSonarr3() {
  sudo apt-get -y update >/dev/null 2>&1
  if [[ $distribution == Debian ]]; then
    sudo apt-get install -y mono-devel >/dev/null 2>&1
  fi
}

function _installSonarr4() {
  sudo apt-get install -y nzbdrone >/dev/null 2>&1
  touch /install/.sonarr.lock
}

function _installSonarr5() {
  sudo chown -R "${username}":"${username}" /opt/NzbDrone
}

function _installSonarr6() {
  cat > /etc/systemd/system/sonarr@.service <<SONARR
[Unit]
Description=nzbdrone
After=syslog.target network.target

[Service]
Type=forking
KillMode=process
User=%I
ExecStart=/usr/bin/screen -f -a -d -m -S nzbdrone mono /opt/NzbDrone/NzbDrone.exe
ExecStop=-/bin/kill -HUP
WorkingDirectory=/home/%I/

[Install]
WantedBy=multi-user.target
SONARR
  systemctl enable sonarr@${username} >/dev/null 2>&1
  systemctl start sonarr@${username}
  sleep 10

  systemctl stop sonarr@{$username}
  sleep 10

  if [[ -f /install/.nginx.lock ]]; then
    bash /usr/local/bin/swizzin/nginx/sonarr.sh
    service nginx reload
  fi
  systemctl restart sonarr@${username}
}


function _installSonarr9() {
  echo "Sonarr Install Complete!" >>"${OUTTO}" 2>&1;
  echo >>"${OUTTO}" 2>&1;
  echo >>"${OUTTO}" 2>&1;
  echo "Close this dialog box to refresh your browser" >>"${OUTTO}" 2>&1;
}

function _installSonarr10() {
  exit
}

if [[ -f /tmp/.install.lock ]]; then
  OUTTO="/root/logs/install.log"
elif [[ -f /install/.panel.lock ]]; then
  OUTTO="/srv/panel/db/output.log"
else
  OUTTO="/dev/null"
fi
username=$(cat /root/.master.info | cut -d: -f1)
distribution=$(lsb_release -is)

_installSonarrintro
echo "Installing latest mono source repository ... " >>"${OUTTO}" 2>&1;_installSonarr1
echo "Adding source repositories for Sonarr-Nzbdrone ... " >>"${OUTTO}" 2>&1;_installSonarr2
echo "Updating your system with new sources ... " >>"${OUTTO}" 2>&1;_installSonarr3
echo "Installing Sonarr-Nzbdrone ... " >>"${OUTTO}" 2>&1;_installSonarr4
echo "Setting permissions to ${username} ... " >>"${OUTTO}" 2>&1;_installSonarr5
echo "Setting up Sonarr as a service and enabling ... " >>"${OUTTO}" 2>&1;_installSonarr6
_installSonarr9
_installSonarr10
