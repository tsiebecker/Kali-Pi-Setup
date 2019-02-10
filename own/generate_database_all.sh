#!/bin/bash

INDIR="files";
OUTDIR="database";
ALL="";

while getopts i:o: arguments; do
  case $arguments in
    i )  INDIR="$OPTARG" ;;
    o )  OUTDIR="$OPTARG" ;;
    a )  ALL="-a" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

for file in ${INDIR}/* ; do ./generate_database_one.sh -i ${file} -o database ${ALL} ; done
