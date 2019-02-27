#!/bin/bash
#this updates various retroarch/libretro files

#check if it's a pc
UNAME=$(uname -m)
if ! [ "$UNAME" = x86_64]; then
    echo "this currently only supports x86_64 linux"
    exit
fi

#check for internet
if ! curl cht.sh; then
    echo "internet found"
else
    echo "no internet"
    exit 1
fi

cd ~

function retroupdate() {
    rm -rf ~/retroarch/"$1"
    mkdir -p ~/retroarch/"$1"
    pushd ~/retroarch/"$1"
    wget "$2"
    unzip *.zip
    rm *.zip
    popd
}

#controller autoconfig
retroupdate autoconfig "https://buildbot.libretro.com/assets/frontend/autoconfig.zip"
#ui assets
retroupdate assets "https://buildbot.libretro.com/assets/frontend/assets.zip"
#game databases for scanning
retroupdate database "https://buildbot.libretro.com/assets/frontend/database-rdb.zip"

#cores
mkdir -p ~/retroarch/cores
pushd ~/retroarch/cores
wget -r --no-parent https://buildbot.libretro.com/nightly/linux/x86_64/latest/
mv */*/*/*/*/*.zip ./
rm -r buildbot*

for zip in *.zip; do
    unzip "$zip"
    rm ./"$zip"
done
popd

echo "done updating"