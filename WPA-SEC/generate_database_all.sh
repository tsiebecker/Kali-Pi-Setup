#!/bin/bash

INDIR="files";
OUTDIR="database";
ALL="";
REMOVE="";
NO_HASHCAT="";

while getopts ai:o:r-: arguments; do
  case $arguments in
    i )  INDIR="$OPTARG" ;;
    o )  OUTDIR="$OPTARG" ;;
    a )  ALL="-a" ;;
    r )  REMOVE="-r" ;;
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
	   noHashcat    )  NO_HASHCAT="--noHashcat" ;;
           noHashcat* )
                       echo "No arg allowed for --$OPTARG option" >&2; exit 2 ;;
           '' )        break ;; # "--" terminates argument processing
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list


if [ "${INDIR: -1}" != "/" ]; then INDIR=${INDIR}"/"; fi

for dir in $(find -L "${INDIR}") ; do name=${dir##*/} ; if [ "${name}" != "${INDIR}" ] && [ -d "${dir}" ]; then ./generate_database_one.sh -i ${dir} -o ${OUTDIR} ${ALL} ${REMOVE} ${NO_HASHCAT} ; fi ; done
