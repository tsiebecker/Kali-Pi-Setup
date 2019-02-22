InterfaceListWireless=()
InterfaceListAll=(/sys/class/net/*)
InterfaceListAll=("${InterfaceListAll[@]//\/sys\/class\/net\//}")
for candidate in "${InterfaceListAll[@]}"; do
    if grep -qs "DEVTYPE=wlan" /sys/class/net/${candidate}/uevent; 
    	then InterfaceListWireless+=("${candidate}")
    fi
done

for interface in "${InterfaceListWireless[@]}"; do
	echo $interface $(basename $(readlink /sys/class/net/$interface/device/driver))
done
