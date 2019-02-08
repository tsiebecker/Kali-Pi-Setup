#!/bin/bash
TIME=20 ;
W=0;

while getopts t:w: option
do
case "${option}"
in
t) TIME=${OPTARG};;
w) W=${OPTARG};;
esac
done

#Alte channels loeschen
rm channels ;


#ifconfig muss wlan1 down sein
#iwconfig muss wlan1 managed sein (also wie beim start)
ifdown wlan${W} || ifdown --force wlan${W} || ip link set wlan${W} down || ifconfig wlan wlan${W} down || echo "Fatal ERROR could NOT set interface wlan${W} down";
iw wlan${W} set type managed
#wenn zu schnell hintereinander ausgeführt: failed to init socket, interface is not up
#Verfuegbare Channel anzeigen (FORM: 1,2,3,4,5,...)
CHANNELLIST="$(hcxdumptool -i wlan${W} -C | grep \d*,\d* | cut -d '=' -f 2 | head --bytes -4)" ;
echo "Verfuegbare Channel: ${CHANNELLIST}" ;

screen -dmS channelgrep bash -c "airodump-ng wlan${W} -c ${CHANNELLIST} 2>&1 | grep 'OPN\|WPA\|WEP' | awk '{print \$6}' &>> channels" ;
echo "airodump-ng gestartet, wird nach ${TIME}s beendet" ;

sleep ${TIME} &&
screen -S channelgrep -p 0 -X quit ;
echo "airodump-ng wurde beendet, channel Liste bereit" ;

#Channel sortieren und Datei ueberschreiben
CHANNELLIST_SORTED="$(sort -un channels |  paste -s -d ',')" ;
echo ${CHANNELLIST_SORTED}&> channels ;
echo "Liste ist soritert" ;
