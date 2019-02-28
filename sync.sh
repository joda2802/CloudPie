#!/bin/bash
if pgrep rclone >/dev/null; then
    echo "rclone already running!"
    exit
fi

if ! rclone --version; then
    echo "please install rclone version 1.46 or higher to use the sync feature"
    exit
fi

USERNAME=$(cat ~/cloudpie/username.txt)
while :; do
    echo "checking password for $USERNAME"
    MEGAPASSWORD=$(rclone cat mega:"$USERNAME"/password.txt)
    USERPASSWORD=$(cat ~/cloudpie/password.txt)
    if [ "$MEGAPASSWORD" = "$USERPASSWORD" ]; then
        echo "passowrd correct"
        rm -rf ~/cloudpie/save
        mkdir -p ~/cloudpie/save
        sleep 1
        echo "mounting saves for $USERNAME"
        rclone mount mega:"$USERNAME/save" ~/cloudpie/save
        sleep 5m

        sleep 2
    else
        echo "wrong password, type in a new one"
    fi
done
