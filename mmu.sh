#!/bin/bash
W=0;
NO_KILL=false;
ERROR=0;
OUT=0;

while getopts w:-: arguments; do
  case $arguments in
    w )  W="$OPTARG" ;;
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
           nokill    )  NO_KILL=true ;;
           nokill* )
                       echo "No arg allowed for --$OPTARG option" >&2; exit 2 ;;
           '' )        break ;; # "--" terminates argument processing
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

:<<'multiline_comment'
while getopts ab:c-: arguments; do
  case $arguments in
    a )  ARG_A=true ;;
    b )  ARG_B="$OPTARG" ;;
    c )  ARG_C=true ;;
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
           alpha    )  ARG_A=true ;;
           bravo=?* )  ARG_B="$LONG_OPTARG" ;;
           bravo*   )  echo "No arg for --$OPTARG option" >&2; exit 2 ;;
           charlie  )  ARG_C=true ;;
           alpha* | charlie* )
                       echo "No arg allowed for --$OPTARG option" >&2; exit 2 ;;
           '' )        break ;; # "--" terminates argument processing
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

When the argument is a dash (-), it has two more components: the flag name and (optionally) its argument. I delimit these the standard way any command would, with the first equals sign (=). $LONG_OPTARG is therefore merely the content of $OPTARG without the flag name or equals sign.

The inner case implements long options manually, so it needs some housekeeping:

    bravo=? matches --bravo=foo but not --bravo= (note: case stops after the first match)
    bravo* follows, noting the missing required argument in --bravo and --bravo=
    alpha* | charlie* catches arguments given to the options that dont support them
    '' is present to support non-options that happen to start with dashes
    * catches all other long options and recreates the error thrown by getopts for an invalid option

You don't necessarily need all of those housekeeping items. For example, perhaps you want --bravo to have an optional argument (which -b can't support due to a limitation in getopts). Merely remove the =? and the related failure case and then call ${ARG_B:=$DEFAULT_ARG_B} the first time you use $ARG_B.

multiline_comment

if [ ${NO_KILL} == false ];
then
	rfkill unblock all || { echo "Fatal ERROR could NOT run \"rfkill unblock all\""; ERROR=1; }
	airmon-ng check kill || { echo "Fatal ERROR could NOT run \"airmon-ng check kill\""; ERROR=1; }
	rfkill unblock all || { echo "Fatal ERROR could NOT run \"rfkill unblock all\""; ERROR=1; }
fi

ifdown wlan${W} || ifdown --force wlan${W} || ip link set wlan${W} down || ifconfig wlan wlan${W} down || { echo "Fatal ERROR could NOT set interface wlan${W} down"; ERROR=1; }

iw dev wlan${W} set power_save off || iwconfig wlan${W} power off || echo "ERROR Stromsparmodus konnte NICHT deaktiviert werden";

iwconfig wlan${W} txpower 50 || if [ $? != 2 ]; then iw dev wlan${W} set txpower fixed 50mBm; fi || { if [ $? != 2 ]; then echo "Fatal ERROR could NOT set txpower on wlan${W}"; ERROR=1; fi }

iw wlan${W} set monitor control || { echo "Warnung, keine \"control\" Packets"; iw wlan${W} set monitor none; } || iw wlan${W} set type monitor || { echo "Warnung, airmon-ng"; airmon-ng start wlan${W}; } || { echo "Fatal ERROR could NOT #start MONITOR-MODE on interface wlan${W}"; ERROR=1; }

ip link set wlan${W} up || { OUT=1; ip link set wlan${W}mon up; } || { OUT=0; ifconfig wlan${W} up; } || { OUT=1; ifconfig wlan${W}mon up; } || { echo "Fatal ERROR could NOT set interface wlan${W} or interface wlan${W}mon up"; ERROR=1; }

if [ ${ERROR} != 1 ];
then
	if [ ${OUT} == 0 ];
	then
		echo "MONITOR-MODE wurde auf interface wlan${W} gestartet :)";
	fi

	if [ ${OUT} == 1 ];
	then
		echo "MONITOR-MODE wurde auf interface wlan${W}mon gestartet :)";
	fi
fi
