#!/bin/sh
#
# This is a simple CLi-based installer. Usually it's used from the website as:
# 
# curl https://www.teleconsole.com/get.sh | sh
#
#
FORMAT="tar.gz"
TARBALL="teleconsole-$$.$FORMAT"
HOST=teleconsole.com
OS=$(uname)
ARCH=$(uname -m)
URL="https://$HOST/client?os=$OS&arch=$ARCH&format=$FORMAT"

# 'teleconsole' will be installed into this dir:
DEST=$HOME/$REPL_SLUG/bin

# find out what's the binary download URL for the latest version
# for this platform and save it as "tarball":
curl -o $TARBALL -L -f $URL

if [ $? -eq 0 ]
then 
    echo "Copying teleconsole binary into $DEST"
    # unpack:
    tar -xzf $TARBALL && sudo mv -f teleconsole $DEST/
    if [ $? -eq 0 ]
    then
        rm $TARBALL
        echo "Teleconsole has been installed into $DEST/teleconsole"
        exit 0
    fi
else
    echo "Failed to determine your platform.\nTry downloading from https://github.com/gravitational/teleconsole/releases"
fi

exit 1
