#!/bin/bash

LD_LIBRARY_PATH=/home/runner/HelpfulDevotedHypertalk/linux-on-proot/.apt/usr/lib/x86_64-linux-gnu:/home/runner/HelpfulDevotedHypertalk/linux-on-proot/.apt/usr/lib:
cd $(dirname $0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command=".apt/usr/bin/proot"
#command+=" --link2symlink"
command+=" -0"
command+=" -r /tmp/.x11-unix/ub-fs"
# if [ -n "$(ls -A ubuntu-binds)" ]; then
#     for f in ubuntu-binds/* ;do
#       . $f
#     done
# fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b /sys"
command+=" -b /tmp/.x11-unix/ub-fs/tmp:/dev/shm"
command+=" -b /:/host-rootfs"
command+=" -b /mnt"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="$@"
if [ -z "$1" ];then
    exec $command
else
    $command -c "$com"
fi
