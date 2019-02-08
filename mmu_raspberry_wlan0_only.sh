airmon-ng check kill
ifconfig wlan0 down
iw wlan0 interface add mon0 type monitor
ifconfig mon0 up
