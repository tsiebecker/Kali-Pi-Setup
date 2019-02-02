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
iw wlan0 interface add mon0 type monitor ;
ifconfig mon0 up ;
ifconfig wlan0 up;
