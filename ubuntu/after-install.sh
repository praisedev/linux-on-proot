#!/bin/bash

#Get the necessary components
apt-mark hold udisks2
[ ! -f /root/.parrot ] && apt-get update || echo "Parrot detected, not updating apt cache since that will break the whole distro"
DEBIAN_FRONTEND=noninteractive apt-get install sudo wget -y
DEBIAN_FRONTEND=noninteractive apt-get update && apt -y install software-properties-common && add-apt-repository ppa:ondrej/php -y && apt-get update && apt install php7.4 php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl mysql-server mysql-client -y

#DEBIAN_FRONTEND=noninteractive apt-get install build-essential net-tools curl git software-properties-common -y
apt-get clean

echo "Running browser patch"
wget https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Uninstall/ubchromiumfix.sh && chmod +x ubchromiumfix.sh
./ubchromiumfix.sh && rm -rf ubchromiumfix.sh

# wget https://www.apachefriends.org/xampp-files/8.0.1/xampp-linux-x64-8.0.1-0-installer.run -O xampp.run
# chmod +x xampp.run
# ./xampp.run
