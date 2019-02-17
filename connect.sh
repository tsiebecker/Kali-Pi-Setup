SSID="";
PW="";
INTERFACE="wlan0";
while getopts n:p:i: arguments; do
  case $arguments in
    n )  SSID="$OPTARG" ;;
    p )  PW="$OPTARG" ;;
    i )  INTERFACE="$OPTARG" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

wpa_passphrase ${SSID} ${PW} > wpa_supplicant.conf.tmp
wpa_supplicant -i${INTERFACE} -cwpa_supplicant.conf.tmp
