#!/bin/bash

INDIR="source";
FILEDIR="files";
DATADIR="database";
ALL="";

while getopts s:f:d: arguments; do
  case $arguments in
    s )  INDIR="$OPTARG" ;;
    f )  FILEDIR="$OPTARG" ;;
    d )  DATADIR="$OPTARG" ;;
    a )  ALL="-a" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

./generate_files_all.sh -i ${INDIR} -o ${FILEDIR}
./generate_database_all.sh -i ${FILEDIR} -o ${DATADIR} ${ALL}
