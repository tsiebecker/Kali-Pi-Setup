#!/bin/bash

INDIR="source";
FILEDIR="files/$(echo -e "$(date)" | tr -d '[:space:]')";
DATADIR="database";
ALL="";
REMOVE="";

while getopts ars:f:d: arguments; do
  case $arguments in
    s )  INDIR="$OPTARG" ;;
    f )  FILEDIR="$OPTARG" ;;
    d )  DATADIR="$OPTARG" ;;
    a )  ALL="-a" ;;
    r )  REMOVE="-r" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

./generate_files_all.sh -i ${INDIR} -o ${FILEDIR} ${REMOVE}
./generate_database_all.sh -i ${FILEDIR} -o ${DATADIR} ${ALL} ${REMOVE}
