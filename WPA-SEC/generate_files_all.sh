#!/bin/bash

INDIR="source";
OUTDIR="files/$(echo -e "$(date)" | tr -d '[:space:]')";
REMOVE="";
BACKUP_DIR="source_old";

while getopts i:o:r-: arguments; do
  case $arguments in
    i )  INDIR="$OPTARG" ;;
    o )  OUTDIR="$OPTARG" ;;
    r )  REMOVE="-r" ;;
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
           BACKUP_DIR=?* )  ARG_B="$LONG_OPTARG" ;;
           BACKUP_DIR*   )  echo "No arg for --$OPTARG option" >&2; exit 2 ;;
           '' )        break ;; # "--" terminates argument processing
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ "${INDIR: -1}" != "/" ]; then INDIR=${INDIR}"/"; fi
if [ "${OUTDIR}" != "" ] ; then mkdir -p ${OUTDIR}; fi
if [ "${OUTDIR: -1}" != "/" ]; then OUTDIR="${OUTDIR}/"; fi


param="" ;
#for file in $(find -L ${INDIR}) ; do name=${file##*/} ; if [ "${name}" != "${INDIR}" ] && [ "${name}" != "" ] ; then ./generate_files_one.sh -i ${file} -o ${OUTDIR}${name}; fi ; done
for file in $(find -L ${INDIR}) ; do name=${file##*/} ; if [ "${name}" != "${INDIR}" ] && [ "${name}" != "" ] && [ -f "${file}" ]; then param="${param} -i ${file}" ; fi ; done ; 

./generate_files_one.sh ${param} -o ${OUTDIR} ${REMOVE} "--BACKUP_DIR=${BACKUP_DIR}"

