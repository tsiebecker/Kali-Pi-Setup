#!/bin/bash

OUTDIR="database";
ALL=false;

while getopts ao: arguments; do
  case $arguments in
    a )  ALL=true ;;
    o )  OUTDIR="$OPTARG" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ "${OUTDIR}" != "" ] ; then mkdir ${OUTDIR}; fi
if [ "${OUTDIR: -1}" != "/" ]; then OUTDIR=${OUTDIR}"/"; fi

hashcat -m 2501 --nonce-error-corrections=128 --remove --logfile-disable -a 0 -w 4 --potfile-path=${OUTDIR}hashcat.2501.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2501 ${OUTDIR}database_best.hccapx ${OUTDIR}"database_pmk(P)_list.db"

sort -u ${OUTDIR}foundhashcat.2501 > ${OUTDIR}foundhashcat.2501.tmp
cat ${OUTDIR}foundhashcat.2501.tmp > ${OUTDIR}foundhashcat.2501
rm ${OUTDIR}foundhashcat.2501.tmp

sort -u ${OUTDIR}hashcat.2501.pot > ${OUTDIR}hashcat.2501.pot.tmp
cat ${OUTDIR}hashcat.2501.pot.tmp > ${OUTDIR}hashcat.2501.pot
rm ${OUTDIR}hashcat.2501.pot.tmp

hashcat -m 2500 --nonce-error-corrections=128 --remove --logfile-disable -a 0 -w 4 --potfile-path=${OUTDIR}hashcat.2500.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2500 ${OUTDIR}database_best.hccapx ${OUTDIR}workinglist.db

sort -u ${OUTDIR}foundhashcat.2500 > ${OUTDIR}foundhashcat.2500.tmp
cat ${OUTDIR}foundhashcat.2500.tmp > ${OUTDIR}foundhashcat.2500
rm ${OUTDIR}foundhashcat.2500.tmp

sort -u ${OUTDIR}hashcat.2500.pot > ${OUTDIR}hashcat.2500.pot.tmp
cat ${OUTDIR}hashcat.2500.pot.tmp > ${OUTDIR}hashcat.2500.pot
rm ${OUTDIR}hashcat.2500.pot.tmp

hcxhashcattool -p ${OUTDIR}hashcat.2500.pot -P ${OUTDIR}"database_pmk(P)_list.db.tmp"

while IFS="" read p || [ -n "$p" ]
do
  echo ${p%%:*} >> ${OUTDIR}"database_pmk(P)_list.db"
done < ${OUTDIR}"database_pmk(P)_list.db.tmp"

sort -u ${OUTDIR}"database_pmk(P)_list.db" > ${OUTDIR}"database_pmk(P)_list.db.tmp"
cat ${OUTDIR}"database_pmk(P)_list.db.tmp" > ${OUTDIR}"database_pmk(P)_list.db"
rm ${OUTDIR}"database_pmk(P)_list.db.tmp"

if [ ${ALL} == true ]
then
	hashcat -m 2501 --nonce-error-corrections=128 --remove --logfile-disable -a 0 -w 4 --potfile-path=${OUTDIR}hashcat.2501.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2501 ${OUTDIR}database_all.hccapx ${OUTDIR}"database_pmk(P)_list.db"
	
	sort -u ${OUTDIR}foundhashcat.2501 > ${OUTDIR}foundhashcat.2501.tmp
	cat ${OUTDIR}foundhashcat.2501.tmp > ${OUTDIR}foundhashcat.2501
	rm ${OUTDIR}foundhashcat.2501.tmp
	
	sort -u ${OUTDIR}hashcat.2501.pot > ${OUTDIR}hashcat.2501.pot.tmp
	cat ${OUTDIR}hashcat.2501.pot.tmp > ${OUTDIR}hashcat.2501.pot
	rm ${OUTDIR}hashcat.2501.pot.tmp

	hashcat -m 2500 --nonce-error-corrections=128 --remove --logfile-disable -a 0 -w 4 --potfile-path=${OUTDIR}hashcat.2500.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2500 ${OUTDIR}database_all.hccapx ${OUTDIR}workinglist.db
	
	sort -u ${OUTDIR}foundhashcat.2500 > ${OUTDIR}foundhashcat.2500.tmp
	cat ${OUTDIR}foundhashcat.2500.tmp > ${OUTDIR}foundhashcat.2500
	rm ${OUTDIR}foundhashcat.2500.tmp
	
	sort -u ${OUTDIR}hashcat.2500.pot > ${OUTDIR}hashcat.2500.pot.tmp
	cat ${OUTDIR}hashcat.2500.pot.tmp > ${OUTDIR}hashcat.2500.pot
	rm ${OUTDIR}hashcat.2500.pot.tmp
	
	hcxhashcattool -p ${OUTDIR}hashcat.2500.pot -P ${OUTDIR}"database_pmk(P)_list.db.tmp"
	
	while IFS="" read p || [ -n "$p" ]
	do
	  echo ${p%%:*} >> ${OUTDIR}"database_pmk(P)_list.db"
	done < ${OUTDIR}"database_pmk(P)_list.db.tmp"
	
	sort -u ${OUTDIR}"database_pmk(P)_list.db" > ${OUTDIR}"database_pmk(P)_list.db.tmp"
	cat ${OUTDIR}"database_pmk(P)_list.db.tmp" > ${OUTDIR}"database_pmk(P)_list.db"
	rm ${OUTDIR}"database_pmk(P)_list.db.tmp"
fi
