#!/usr/bin/env bash
function zerocheck() {
    if [ -z "$1" ]; then
        exit
    fi
}

function changeconf() {
    if [ -z "$2" ]; then
        echo "usage: changeconf option value"
    fi
    if [ -z "$3" ]; then
        if ! [ -e ~/.config/retroarch/retroarch.cfg ]; then
            echo "generating config"
            timeout 5 ~/cloudpie/path/retroarch
        fi
        pushd ~/.config/retroarch
        NEWVALUE="$1 = \"$2\""
        sed -i "/$1/c $NEWVALUE" retroarch.cfg
        popd
    fi

}

function cget() {
    if [ -z "$1" ]; then
        echo "usage: cget filename"
    else
        for file in "$@"; do
            wget https://raw.githubusercontent.com/paperbenni/CloudPie/master/"$file"
        done
    fi
}

function retroupdate() {
    rm -rf ~/retroarch/"$1"
    mkdir -p ~/retroarch/"$1"
    pushd ~/retroarch/"$1"
    wget "$2"
    unzip -o *.zip
    rm *.zip
    popd
}

function retro() {
    ~/cloudpie/path/retroarch -L "$HOME/retroarch/cores/$1.so" "$2"
}

function openrom() {
    if ! [ -e "$1" ]; then
        echo "$1 not found"
        exit 0
    fi
    case "$2" in
    n64)
        retro "parallel_n64_libretro" "$1"
        ;;
    ds)
        retro "desmume2015_libretro" "$1"
        ;;
    snes)
        retro "snes9x_libretro" "$1"
        ;;
    psx)
        retro "pcsx_rearmed_libretro" "$1"
        ;;
    gba)
        retro "vbam_libretro" "$1"
        ;;
    *)
        echo "no core found for $2"
        ;;
    esac

}
