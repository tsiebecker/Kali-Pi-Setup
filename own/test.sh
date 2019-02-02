#!/bin/bash
while getopts t:d:p:f: option
do
case "${option}"
in
t) TIME=${OPTARG};;
c) CHANNELLIST=${OPTARG};;
p) PRODUCT=${OPTARG};;
f) FORMAT=$OPTARG;;
esac
done

rm channels ||


#Verfuegbare Channel anzeigen (FORM: 1,2,3,4,5,...)
$CHANNELLIST = "$(hcxdumptool -i wlan1 -C | grep \d*,\d* | cut -d '=' -f 2 | head --bytes -4&>> channels)";
#screen -dmS getchannel bash -c "hcxdumptool -i wlan1 -C | grep \d*,\d* | cut -d '=' -f 2 | head --bytes -4&>> channels" &&


#Nur Zahlen: grep -o '[0-9]+'
screen -dmS channelgrep bash -c "airodump-ng wlan1 -c $CHANNELLIST 2>&1 | grep 'OPN\|WPA\|WEP' | awk '{print \$6}' &>> channels" &

# $TIME = 20;

sleep 600 &&
screen -S channelgrep -p 0 -X quit && 
screen -dmS channelsort bash -c "sort -un channels |  paste -s -d ',' &>> channels.tmp && rm channels && mv channels.tmp channels"
