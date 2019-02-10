#!/bin/bash

INDIR="source";
OUTDIR="files";

while getopts i:o: arguments; do
  case $arguments in
    i )  INDIR="$OPTARG" ;;
    o )  OUTDIR="$OPTARG" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ "${INDIR: -1}" != "/" ]; then INDIR=${INDIR}"/"; fi
if [ "${OUTDIR}" != "" ] ; then mkdir ${OUTDIR}; fi
if [ "${OUTDIR: -1}" != "/" ]; then OUTDIR="${OUTDIR}/"; fi

for file in find -L ${INDIR} ; do name=${file##*/} ; if [ ${name} != ${INDIR} ]; then ./generate_files_one.sh -i ${file} -o ${OUTDIR}${name}; fi ; done
