#!/bin/sh
airmon-ng check kill ;
ifdown --force wlan1 ;
ifconfig wlan1 down ;
iwconfig wlan1 mode monitor &&
iwconfig wlan1 txpower &&
ifconfig wlan1 up ;