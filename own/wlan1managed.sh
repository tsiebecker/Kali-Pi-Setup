#!/bin/sh
airmon-ng check kill ;
ifdown --force wlan1 ;
ifconfig wlan1 down ;
iwconfig wlan1 mode managed &&
iwconfig wlan1 txpower 40 &&
ifconfig wlan1 up ;