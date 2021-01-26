#!/bin/bash

#Get the necessary components
apt-mark hold udisks2
[ ! -f /root/.parrot ] && apt-get update || echo "Parrot detected, not updating apt cache since that will break the whole distro"
DEBIAN_FRONTEND=noninteractive apt-get install keyboard-configuration -y
DEBIAN_FRONTEND=noninteractive apt-get install sudo wget -y
DEBIAN_FRONTEND=noninteractive apt-get install xfce4 xfce4-terminal xfce4-goodies tigervnc-standalone-server novnc websockify python3-numpy build-essential net-tools curl git software-properties-common firefox -y
DEBIAN_FRONTEND=noninteractive apt-get install xfe -y
apt-get clean

#Setup the necessary files
mkdir ~/.vnc
wget https://raw.githubusercontent.com/Techriz/AndronixOrigin/master/APT/XFCE4/xstartup -P ~/.vnc/
wget https://raw.githubusercontent.com/Techriz/AndronixOrigin/master/APT/XFCE4/vncserver-start -P /usr/local/bin/
wget https://raw.githubusercontent.com/Techriz/AndronixOrigin/master/APT/XFCE4/vncserver-stop -P /usr/local/bin/

chmod +x ~/.vnc/xstartup
chmod +x /usr/local/bin/vncserver-start
chmod +x /usr/local/bin/vncserver-stop

echo "Running browser patch"
wget https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Uninstall/ubchromiumfix.sh && chmod +x ubchromiumfix.sh
./ubchromiumfix.sh && rm -rf ubchromiumfix.sh

echo "export DISPLAY=":1"" >> /etc/profile
source /etc/profile

vncserver-start
vncserver -kill :1

vncpasswd
cd /etc/ssl ; openssl req -x509 -nodes -newkey rsa:2048 -keyout novnc.pem -out novnc.pem -days 365
chmod 644 novnc.pem
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 12345 localhost:5901