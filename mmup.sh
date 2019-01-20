airmon-ng check kill &&
ifconfig wlan1 down &&
iwconfig wlan1 mode monitor &&
iw wlan1 set channel 1 HT40+ &&
iwconfig wlan1 txpower 40 &&
ifconfig wlan1 up &&
hcxdumptool -i wlan1 -t 60 -o captured/eap_eapol.pcapng -O captured/unencrypred_ip4_ip6.pcapng -W captured/encrypted_wep.pcapng -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14 --enable_status=1 --enable_status=2 --enable_status=4 --enable_status=8 --enable_status=16 --filterlist=myWIFI --filtermode=1
