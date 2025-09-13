#!/bin/sh

ip=$(ip addr | grep "192.168.0.255" | cut -c10-22)

if [ "$ip" ]; then
    echo $ip
else
    echo "No WiFi"
fi

exit 0
