airmon-ng check kill

#./mmu.sh -w 1
#./mmu.sh -w 2

screen -dmS gps gpsd -N -n -D5 tcp://192.168.43.1:4352

sleep 10



#adb forward tcp:4352 tcp:4352

#if [ $? != 0 ]
#then
#	while [ $? != 0 ]
#	do
#		adb forward tcp:4352 tcp:4352
#	done
#fi

#modprobe bnep
#hciconfig hci0 lm master,accept
#hciconfig hci0 sspmode 0

#bt-pan server pan0 &
#sleep 5
#blueagent5 --pin 1111 &

#sysctl -w net.ipv4.ip_forward=1

#iptables -A INPUT -i pan0 -j ACCEPT
#iptables -A FORWARD -i pan0 -j ACCEPT

#sleep 5

#screen -dmS gps gpsd -N -n -D5 tcp://192.168.0.42:4352

#sleep 5 

screen -dmS wlan1 hcxdumptool -i wlan1 -o captured/o.cap -O captured/O.cap -W captured/W.cap -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14 --enable_status=1 --enable_status=2 --enable_status=4 --enable_status=8 --enable_status=16 --use_gpsd --filterlist=myWIFI --filtermode=1
#screen -dmS wlan2 hcxdumptool -i wlan2 -o captured/o.cap -O captured/O.cap -W captured/W.cap -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14 --enable_status=1 --enable_status=2 --enable_status=4 --enable_status=8 --enable_status=16 --use_gpsd --filterlist=myWIFI --filtermode=1
screen -ls
