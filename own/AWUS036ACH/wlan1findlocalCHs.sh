#!/bin/bash
TIME=20 ;

while getopts t: option
do
case "${option}"
in
t) TIME=${OPTARG};;
esac
done

#Alte channels loeschen
rm channels ;


#ifconfig muss wlan1 down sein
#iwconfig muss wlan1 managed sein (also wie beim start)
ifdown --force wlan1 ;
ifconfig wlan1 down ;

#wenn zu schnell hintereinander ausgef  hrt: failed to init socket, interface is not up
#Verfuegbare Channel anzeigen (FORM: 1,2,3,4,5,...)
CHANNELLIST="$(hcxdumptool -i wlan1 -C | grep \d*,\d* | cut -d '=' -f 2 | head --bytes -4)" ;
echo "Verfuegbare Channel: ${CHANNELLIST}" ;

screen -dmS channelgrep bash -c "airodump-ng wlan1 -c ${CHANNELLIST} 2>&1 | grep 'OPN\|WPA\|WEP' | awk '{print \$6}'$
echo "airodump-ng gestartet, wird nach ${TIME}s beendet" ;

sleep ${TIME} &&
screen -S channelgrep -p 0 -X quit ;
echo "airodump-ng wurde beendet, channel Liste bereit" ;

#Channel sortieren und Datei ueberschreiben
CHANNELLIST_SORTED="$(sort -un channels |  paste -s -d ',')" ;
echo ${CHANNELLIST_SORTED}&> channels ;
echo "Liste ist soritert" ;
