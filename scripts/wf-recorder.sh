#!/bin/sh

printf "1. None\n2. Microphone\n3. Desktop\n"
read -p "Select audio source (1/2/3): " option
printf "\n"
read -p "Open webcam? (Y/N): " webcam

if [ $option = "2" ]; then
    audioin="-aalsa_input.pci-0000_05_00.6.analog-stereo" # pactl list sources | grep Name
    printf "\n\nUsing microphone\n\n"
elif [ $option = "3" ]; then
    audioin="-aalsa_output.pci-0000_05_00.6.analog-stereo.monitor" # pactl list sources | grep Name
    printf "\n\nUsing desktop audio\n\n"
else
    audioin=""
    printf "\n\nNo audio\n\n"
fi

read -p "Press enter to start." none

if [ $webcam = "y" ] ||  [ $webcam = "Y" ]; then
    mpv av://v4l2:/dev/video0 --profile=low-latency --untimed=yes --video-latency-hacks=yes --wayland-internal-vsync=yes --video-sync=display-desync &
fi

path="$HOME/Videos/"
file=$path$(date | tr " " "_")

#wf-recorder $audioin -c libx264 -r 30 -f $file.mkv
wf-recorder $audioin -c h264_vaapi -r 30 -f $file.mkv

exit 0
