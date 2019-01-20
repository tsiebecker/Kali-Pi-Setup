ifconfig wlan1 down &&
iwconfig wlan1 mode managed &&
ifconfig wlan1 up &&
ifconfig wlan1 down
#service NetworkManager restart &&
#service wpa_supplicant restart
