#!/bin/sh

# Call this script via cron however often you want to check for updates

# Where to store package archives
path="$HOME/.pkgs/"
# See end of file for more config

updates=""
repoindex=""
repo=""

getUpdate () {
    target=$1
    fname1=$(echo $target | cut -d "*" -f 1)
    fname2=$(echo $target | cut -d "*" -f 2)
    if [ "$repo" != "$2" ]; then
        repo=$2
        repoindex=$(curl $repo)
    fi
    ver=$(\
    echo $repoindex \
    | grep -o "\b$fname1[^A-Za-z]*$fname2\b" \
    | sed -E "s/$fname2//" \
    | sed -E "s/$fname1//" \
    | sort -u
    )
    file=$fname1$ver$fname2
    current=$(ls $path | grep "$fname1.*$fname2")

    if [ "$file" != "$current" ]; then
        printf "\n\nUpdating $file\n\n"
        rm -f $path$target && curl $repo$file > $path$file
        updates=$updates"- pacman -U $path$file\n"
    fi
}

# Packages to keep track of, replace the version with a "*"
# Format: getUpdate "archive-file" "repo-index"
# Examples:

# linux-libre-lts
#getUpdate "linux-libre-lts-*-x86_64.pkg.tar.xz" "https://repo.parabola.nu/libre/os/x86_64/"
# linux-libre-firmware
#getUpdate "linux-libre-firmware-*-any.pkg.tar.xz" "https://repo.parabola.nu/libre/os/x86_64/"
# rcs
#getUpdate "rcs-*-x86_64.pkg.tar.zst" "https://mirror.moson.org/arch/extra/os/x86_64/"

# Add a path to an empty .sh here (eg $HOME/.scripts/updates.sh)
# and source it in your .bashrc to get notified when you have updates
notiscript=""
if [ "$updates" != "" ] && [ "$notiscript" != "" ]; then
    printf "\n
    printf 'You have new updates!\n\nUpdate with:\n$updates\n'
    read -p 'Press Y to clear or any key to close this popup.' -n1 option
    if [ \$option = 'Y' ] || [ \$option = 'y' ]; then
        echo '' > $notiscript
    fi
    clear" > $notiscript
fi

exit 0
