#!/bin/bash

LD_LIBRARY_PATH=$PWD/.apt/usr/lib/x86_64-linux-gnu:$PWD/.apt/usr/lib:

time1="$( date +"%r" )"

install1 () {
directory=/tmp/.x11-unix/ub-fs
UBUNTU_VERSION=18.04
if [ -d "$directory" ];then
first=1
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;227m[WARNING]:\e[0m \x1b[38;5;87m Skipping the download and the extraction\n"
# elif [ -z "$(command -v proot)" ];then
# printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Please install proot.\n"
# printf "\e[0m"
# exit 1
elif [ -z "$(command -v wget)" ];then
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Please install wget.\n"
printf "\e[0m"
exit 1
fi
if [ "$first" != 1 ];then
if [ -f "ubuntu.tar.gz" ];then
rm -rf ubuntu.tar.gz
fi
if [ ! -f "ubuntu.tar.gz" ];then
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Downloading the ubuntu rootfs, please wait...\n"
ARCHITECTURE=$(dpkg --print-architecture)
case "$ARCHITECTURE" in
aarch64) ARCHITECTURE=arm64;;
arm) ARCHITECTURE=armhf;;
amd64|x86_64) ARCHITECTURE=amd64;;
x86|i*86) ARCHITECTURE=i386;;
*)
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Unknown architecture :- $ARCHITECTURE"
exit 1
;;

esac

#wget https://github.com/AndronixApp/AndronixOrigin/blob/master/Rootfs/Ubuntu20/focal-amd64.tar.gz?raw=true -q -O ubuntu.tar.gz 

wget http://cdimage.ubuntu.com/ubuntu-base/releases/18.04/release/ubuntu-base-18.04.5-base-amd64.tar.gz -q -O ubuntu.tar.gz 

printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Download complete!\n"

fi

cur=`pwd`
mkdir -p $directory
cd $directory
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Decompressing the ubuntu rootfs, please wait...\n"
tar -zxf $cur/ubuntu.tar.gz --exclude='dev'||:
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m The ubuntu rootfs have been successfully decompressed!\n"
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Fixing the resolv.conf, so that you have access to the internet\n"
printf "search c.marine-cycle-160323.internal google.internal\nnameserver 127.0.0.11\noptions ndots:0" > etc/resolv.conf
stubs=()
stubs+=('usr/bin/groups')
for f in ${stubs[@]};do
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Writing stubs, please wait...\n"
echo -e "#!/bin/sh\nexit" > "$f"
done
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Successfully wrote stubs!\n"
cd $cur

fi

mkdir -p ub-binds
bin=su.sh
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Creating the start script, please wait...\n"
cat > $bin <<- EOM
#!/bin/bash

LD_LIBRARY_PATH=$PWD/.apt/usr/lib/x86_64-linux-gnu:$PWD/.apt/usr/lib:
cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command=".apt/usr/bin/proot"
#command+=" --link2symlink"
command+=" -0"
command+=" -r $directory"
# if [ -n "\$(ls -A ubuntu-binds)" ]; then
#     for f in ubuntu-binds/* ;do
#       . \$f
#     done
# fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b /sys"
command+=" -b $directory/tmp:/dev/shm"
command+=" -b /:/host-rootfs"
command+=" -b /mnt"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m The start script has been successfully created!\n"
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Fixing shebang of startubuntu.sh, please wait...\n"
termux-fix-shebang $bin
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Successfully fixed shebang of startubuntu.sh! \n"
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Making startubuntu.sh executable please wait...\n"
chmod +x $bin
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Successfully made startubuntu.sh executable\n"
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Cleaning up please wait...\n"
rm ubuntu.tar.gz -rf
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m Successfully cleaned up!\n"
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[Installer thread/INFO]:\e[0m \x1b[38;5;87m The installation has been completed! You can now launch Ubuntu with ./su.sh\n"
printf "\e[0m"

}
if [ "$1" = "-y" ];then
install1
elif [ "$1" = "" ];then
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;127m[QUESTION]:\e[0m \x1b[38;5;87m Do you want to install ubuntu-in-termux? [Y/n] "

read cmd1
if [ "$cmd1" = "y" ];then
install1
elif [ "$cmd1" = "Y" ];then
install1
else
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Installation aborted.\n"
printf "\e[0m"
exit
fi
else
printf "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Installation aborted.\n"
printf "\e[0m"
fi

EOM

export DEBIAN_FRONTEND=noninteractive

dlink="https://raw.githubusercontent.com/praisedev/linux-on-proot/main/ubuntu"
wget $dlink/after-install.sh -O $directory/root/after-install.sh
clear
echo "Setting up the installation"

echo "APT::Acquire::Retries \"3\";" > $directory/etc/apt/apt.conf.d/80-retries #Setting APT retry count
echo "#!/bin/bash
apt update -y && apt install sudo wget -y
clear
if [ ! -f /root/after-install.sh ]; then
    wget --tries=20 $dlink/after-install.sh -O /root/after-install.sh
    bash ~/after-install.sh
else
    bash ~/after-install.sh
fi
clear
rm -rf ~/.bash_profile" >> $directory/root/.bash_profile 

bash $bin
