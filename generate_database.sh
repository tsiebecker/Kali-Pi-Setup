cat o >> database_best.hccapx
cat o O >> database_all.hccapx
cat z >> database_pmkid_only.hccapx

cat E >> "database_probe(E)_list.db"
sort -u "database_probe(E)_list.db" > "database_probe(E)_list.db.tmp"
cat "database_probe(E)_list.db.tmp" > "database_probe(E)_list.db"
rm "database_probe(E)_list.db.tmp"

cat I >> "database_identitiy(I)_list.db"
sort -u "database_identitiy(I)_list.db" > "database_identitiy(I)_list.db.tmp"
cat "database_identitiy(I)_list.db.tmp" > "database_identitiy(I)_list.db"
rm "database_identitiy(I)_list.db.tmp"

cat U >> "database_username(U)_list.db"
sort -u "database_username(U)_list.db" > "database_username(U)_list.db.tmp"
cat "database_username(U)_list.db.tmp" > "database_username(U)_list.db"
rm "database_username(U)_list.db.tmp"

cat P >> "database_pmk(P)_list.db"
sort -u "database_pmk(P)_list.db" > "database_pmk(P)_list.db.tmp"
cat "database_pmk(P)_list.db.tmp" > "database_pmk(P)_list.db"
rm "database_pmk(P)_list.db.tmp"

cat database_*_list.db > "workinglist.tmp"
sort -u "workinglist.tmp" > "workinglist.db"
rm "workinglist.tmp"

##run workinglist against your database_best and use --potfile option of hashcat
#hashcat -m 2500 database_best.hccapx -a 0 -w 4 -o out.pot workinglist.db
#hashcat -m 2500 --remove --logfile-disable --potfile-path=out.pot --outfile-format=2 -o foundhashcat.2500 database_best.hccapx database_pmk(P)_list.db
##Original:
##hashcat -m 2501 --remove --logfile-disable --potfile-path=hashcat.2501.pot --outfile-format=2 -o foundhashcat.2501 test.hccapx pmklist

##create pmklist from hashcat.2500 potfile
##cat pmklist >> databasepmklist
##from now on, you can run pmklist in combination with --remove against your database and(or incomming to remove allready cracked ones in a very fast way.



cat j >> "database_john(j)_list.db"
sort -u "database_john(j)_list.db" > "database_john(j).db.tmp"
cat "database_john(j).db.tmp" > "database_john(j)_list.db"
rm "database_john(j).db.tmp"

cat J >> "database_johnRaw(J)_list.db"
sort -u "database_johnRaw(J)_list.db" > "database_johnRaw(J).db.tmp"
cat "database_johnRaw(J).db.tmp" > "database_johnRaw(J)_list.db"
rm "database_johnRaw(J).db.tmp"

cat T >> "database_mgmtTraffic(T)_list.db"
sort -u "database_mgmtTraffic(T)_list.db" > "database_mgmtTraffic(T)_list.db.tmp"
cat "database_mgmtTraffic(T)_list.db.tmp" > "database_mgmtTraffic(T)_list.db"
rm "database_mgmtTraffic(T)_list.db.tmp"

cat g >> "database_GPS(g)_list.db"
sort -u "database_GPS(g)_list.db" > "database_GPS(g)_list.db.tmp"
cat "database_GPS(g)_list.db.tmp" > "database_GPS(g)_list.db"
rm "database_GPS(g)_list.db.tmp"



:<<'multiline_comment'
Now put your focus on common ESSIDs and get them:
wlanhcx2ssid -i database_xxx.hccapx -X default (you can do this on best and/or raw)
In this case you get full advantage of reuse PBKDF2 on default.hccapx for common ESSIDs

If you need a single ESSID:
wlanhcx2ssid -i database_best.hccapx -w forced.hccapx

Retrieve info about converted networks:
wlanhcxinfo -i forced.hccapx -a -s -e | sort | uniq

and get exact the network you like to attack by mac or ESSID or whatever you like:
wlanhcx2ssid -i forced.hccapx -A mac_ap

Do not try to run useless wordlists found in www (and most of them are useless for your purpose)
Analyze your potfile to get informations about the keyspace of similar networks (same VENDOR and/or ISP)
Use -O option of hcxpcaptool (maybe a clients made a typo - half PSK, you are able to crack)
Analyze probelist (myabe PSK or simlilar PSK is inside)
Build your own wordlist based on your database lists and run rules on them
cat database lists and cracked to one list and run princeattack
Annoy the client to retrieve his NVRAM and or PSK - longterm: hcxdumptool -i interface -o record.pcap -t 60 -D -b blacklisthome
(that is not the same like a "normal" rogue AP or an evil twin - we are on protocol level)
multiline_comment
