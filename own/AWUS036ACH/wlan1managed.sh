#!/bin/bash
while getopts kill: option
do
case "${option}"
in
kill) KILL=${OPTARG};;
esac
done

airmon-ng check kill ;
ifdown --force wlan1 ;
ifconfig wlan1 down ;
iwconfig wlan1 mode managed ;
iwconfig wlan1 txpower 40 ;
ifup wlan1 ;
ifconfig wlan1 up ;