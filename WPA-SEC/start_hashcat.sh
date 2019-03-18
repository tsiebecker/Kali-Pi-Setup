#!/bin/bash

OUTDIR="database";
ALL=false;
NONCE_ERROR_CORRECTIONS=128;
COOPTIONS="-a 0 -w 4 -D 1,2"

while getopts ao:d:-: arguments; do
  case $arguments in
    a )  ALL=true ;;
    o )  OUTDIR="$OPTARG" ;;
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
	   NONCE_ERROR_CORRECTIONS=?* )  NONCE_ERROR_CORRECTIONS="$LONG_OPTARG" ;;
	   NONCE_ERROR_CORRECTIONS*   )  echo "No arg for --$OPTARG option" >&2; exit 2 ;;
	   COOPTIONS=?* )  COOPTIONS="$LONG_OPTARG" ;;
	   COOPTIONS*   )  echo "No arg for --$OPTARG option" >&2; exit 2 ;;
           '' )        break ;; # "--" terminates argument processing
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ "${OUTDIR}" != "" ] ; then mkdir ${OUTDIR}; fi
if [ "${OUTDIR: -1}" != "/" ]; then OUTDIR=${OUTDIR}"/"; fi

hashcat -m 2501 --nonce-error-corrections=${NONCE_ERROR_CORRECTIONS} --remove --logfile-disable ${COOPTIONS} --potfile-path=${OUTDIR}hashcat.2501.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2501 ${OUTDIR}database_best.hccapx ${OUTDIR}"database_pmk(P)_list.db"

sort -uo ${OUTDIR}foundhashcat.2501 ${OUTDIR}foundhashcat.2501

sort -uo ${OUTDIR}hashcat.2501.pot ${OUTDIR}hashcat.2501.pot

hashcat -m 2500 --nonce-error-corrections=${NONCE_ERROR_CORRECTIONS} --remove --logfile-disable ${COOPTIONS} --potfile-path=${OUTDIR}hashcat.2500.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2500 ${OUTDIR}database_best.hccapx ${OUTDIR}workinglist.db

sort -uo ${OUTDIR}foundhashcat.2500 ${OUTDIR}foundhashcat.2500

sort -uo ${OUTDIR}hashcat.2500.pot ${OUTDIR}hashcat.2500.pot

hcxhashcattool -p ${OUTDIR}hashcat.2500.pot -P ${OUTDIR}"database_pmk(P)_list.db.tmp"

while IFS="" read p || [ -n "$p" ]
do
  echo ${p%%:*} >> ${OUTDIR}"database_pmk(P)_list.db"
done < ${OUTDIR}"database_pmk(P)_list.db.tmp"

rm ${OUTDIR}"database_pmk(P)_list.db.tmp"

sort -uo ${OUTDIR}"database_pmk(P)_list.db" ${OUTDIR}"database_pmk(P)_list.db"

if [ ${ALL} == true ]
then
	hashcat -m 2501 --nonce-error-corrections=${NONCE_ERROR_CORRECTIONS} --remove --logfile-disable ${COOPTIONS} --potfile-path=${OUTDIR}hashcat.2501.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2501 ${OUTDIR}database_all.hccapx ${OUTDIR}"database_pmk(P)_list.db"
	
	sort -uo ${OUTDIR}foundhashcat.2501 ${OUTDIR}foundhashcat.2501

	sort -uo ${OUTDIR}hashcat.2501.pot ${OUTDIR}hashcat.2501.pot

	hashcat -m 2500 --nonce-error-corrections=${NONCE_ERROR_CORRECTIONS} --remove --logfile-disable ${COOPTIONS} --potfile-path=${OUTDIR}hashcat.2500.pot --outfile-format=2 -o ${OUTDIR}foundhashcat.2500 ${OUTDIR}database_all.hccapx ${OUTDIR}workinglist.db
	
	sort -uo ${OUTDIR}foundhashcat.2500 ${OUTDIR}foundhashcat.2500

	sort -uo ${OUTDIR}hashcat.2500.pot ${OUTDIR}hashcat.2500.pot

	hcxhashcattool -p ${OUTDIR}hashcat.2500.pot -P ${OUTDIR}"database_pmk(P)_list.db.tmp"
	
	while IFS="" read p || [ -n "$p" ]
	do
	  echo ${p%%:*} >> ${OUTDIR}"database_pmk(P)_list.db"
	done < ${OUTDIR}"database_pmk(P)_list.db.tmp"
	
	rm ${OUTDIR}"database_pmk(P)_list.db.tmp"
	
	sort -uo ${OUTDIR}"database_pmk(P)_list.db" ${OUTDIR}"database_pmk(P)_list.db"
	
fi
