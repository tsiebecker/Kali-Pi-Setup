#!/bin/bash
#The IP for the server you wish to ping (8.8.8.8 is a 
# public Google DNS server)
SERVER=8.8.8.8
# Only send two pings, sending output to /dev/null
#ping -c2 ${SERVER} > /dev/null
# If the return code from ping ($?) is not 0 (meaning there was an 
# error)
#if [ $? != 0 ] then
#    # Restart the wireless interface
#    ifdown --force wlan0 
#    ifup wlan0
#fi 
T="true"
while [ 1 ]
        do
	sleep 10 
        ping -c 1 ${SERVER} && wait $! 
        if [ $? != 0 ]
        then
#		ifdown --force wlan0
#               ifdown wlan0 || ifup --force wlan0 || 
	       service networking restart
#	       ifconfig wlan0 down || ifconfig wlan0 up
# || dhclient -r wlan0 || dhclient -v wlan0
#               sudo wpa_cli -i wlan0 reconfigure
               sleep 5
        else T="false"
        fi
done
