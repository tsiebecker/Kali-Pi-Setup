#!/bin/bash

OUTDIR="database";
ALL=false;
INDIR="dicts/";
EXEPT="ALL.txt";

while getopts ao:i:e: arguments; do
  case $arguments in
    a )  ALL=true ;;
    o )  OUTDIR="$OPTARG" ;;
    i )  INDIR="$OPTARG" ;;
    e )  EXEPT="$OPTARG" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ "${INDIR: -1}" != "/" ]; then INDIR=${INDIR}"/"; fi
if [ "${OUTDIR}" != "" ] ; then mkdir ${OUTDIR}; fi
if [ "${OUTDIR: -1}" != "/" ]; then OUTDIR=${OUTDIR}"/"; fi

fileArray=();
sizeArray=();
size=0;

for file in $(find -L ${INDIR}) ; do name=${file##*/} ; if [ "${name}" != "${INDIR}" ] && [ "${name}" != "" ] && [ "${name}" != "${EXEPT}" ] ; then fileArray+=("$file") ; size=(`du -k "$file" | cut -f1`) ; sizeArray+=("$size") ;fi ; done ; 

#echo ${fileArray[@]}

#readarray -t sortedArray < <(printf '%s\0' "${sizeArray[@]}" | sort -z | xargs -0n1)
readarray -t sortedArray < <(for a in "${sizeArray[@]}"; do echo "${a}" ; done | sort -V)
fileArraysorted=();
for i in "${!sortedArray[@]}"; do
	for j in "${!sizeArray[@]}"; do
			if [ ${sortedArray[i]} == ${sizeArray[j]} ]; then
				#echo ${sortedArray[i]}${sizeArray[j]}
				#echo ${fileArray[j]}${sizeArray[j]};  				
				sizeArray[j]=0;
				sizeArray[j]=$((int-1));
				
				fileArraysorted+=("${fileArray[j]}") ;
				
				
   			fi
	done
done

for k in ${!fileArraysorted[@]} ; do
	
	hashcat -m 2500 --nonce-error-corrections=128 --remove --logfile-disable -a 0 -w 4 --potfile-path=${OUTDIR}hashcat.2500.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2500 ${OUTDIR}database_best.hccapx ${fileArraysorted[k]}
	#echo fileArraysorted[0]

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
done

if [ ${ALL} == true ]
then
	for l in "${!fileArraysorted[@]}"; do
		hashcat -m 2501 --nonce-error-corrections=128 --remove --logfile-disable -a 0 -w 4 --potfile-path=${OUTDIR}hashcat.2501.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2501 ${OUTDIR}database_all.hccapx ${OUTDIR}"database_pmk(P)_list.db"
	
		sort -u ${OUTDIR}foundhashcat.2501 > ${OUTDIR}foundhashcat.2501.tmp
		cat ${OUTDIR}foundhashcat.2501.tmp > ${OUTDIR}foundhashcat.2501
		rm ${OUTDIR}foundhashcat.2501.tmp
	
		sort -u ${OUTDIR}hashcat.2501.pot > ${OUTDIR}hashcat.2501.pot.tmp
		cat ${OUTDIR}hashcat.2501.pot.tmp > ${OUTDIR}hashcat.2501.pot
		rm ${OUTDIR}hashcat.2501.pot.tmp
	
		hashcat -m 2500 --nonce-error-corrections=128 --remove --logfile-disable -a 0 -w 4 --potfile-path=${OUTDIR}hashcat.2500.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2500 ${OUTDIR}database_all.hccapx ${fileArraysorted[l]}
	
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
	done
fi

