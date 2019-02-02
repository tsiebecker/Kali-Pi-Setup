#!/bin/bash
while getopts kill: option
do
case "${option}"
in
kill) KILL=${OPTARG};;
esac
done

airmon-ng check kill ;
ifdown --force mon0 ;
ifdown --force wlan0 ;   
ifconfig mon0 down ;
ifconfig wlan0 down ;
iw dev mon0 del ;
iwconfig wlan0 mode managed ;
#Funktioniert aktuell nicht, nexutil -m => segmentation fault
#einzige Lösung : shutdown -rF now
ifup wlan0 ;
ifconfig wlan0 up;
