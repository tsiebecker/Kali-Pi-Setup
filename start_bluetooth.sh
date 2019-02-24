ifconfig pan0 up
iptables -F
iptables -X
iptables -t nat -F
iptables -A FORWARD -o bond0 -i pan0 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o bond0 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1
modprobe bnep
hciconfig hci0 lm master,accept
hciconfig hci0 sspmode 0
screen -dmS bt-pan bt-pan server pan0
sleep 5
screen -dmS blueagent5 blueagent5 --pin 7395
