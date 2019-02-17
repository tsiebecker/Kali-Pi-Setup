#!/bin/bash

W="";

while getopts w: arguments; do
  case $arguments in
    w )  W="$OPTARG" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

mkdir captured

screen -dmS wlan${W} hcxdumptool -i wlan${W} -o captured/o.cap -O captured/O.cap -W captured/W.cap -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14 --enable_status=1 --enable_status=2 --enable_status=4 --enable_status=8 --enable_status=16

screen -ls
