#!/bin/sh

printf "1. None\n2. Microphone\n3. Desktop\n"
read -p "Select audio source (1/2/3): " -n1 option
printf "\n"
read -p "Open webcam? (Y/N): " -n1 webcam

if [ $option = "2" ]; then
    audioin="-f pulse -i alsa_input.pci-0000_05_00.6.analog-stereo" # pactl list sources | grep Name
    printf "\n\nUsing microphone\n\n"
elif [ $option = "3" ]; then
    audioin="-f pulse -i alsa_output.pci-0000_05_00.6.analog-stereo.monitor" # pactl list sources | grep Name
    printf "\n\nUsing desktop audio\n\n"
else
    audioin=""
    printf "\n\nNo audio\n\n"
fi

read -p "Press enter to start." -n1

if [ $webcam = "y" ] ||  [ $webcam = "Y" ]; then
    mpv av://v4l2:/dev/video0 --profile=low-latency --untimed=yes --video-latency-hacks=yes --video-sync=display-desync &
fi

path="$HOME/Videos/"
file=$path$(date | tr " " "_")

ffmpeg -s 1920x1080 -f x11grab -r 30 -i :0.0 -c:v h264 $audioin "$file.mkv"

exit 0
