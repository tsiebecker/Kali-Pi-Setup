OUTDIR="captured";
W="0" ;
CHANNELS="1,2,3,4,5,6,7,8,9,10,11,12,13,14";
TIME="5";
NO_LOG=false;
NO_SCREEN=false;

while getopts o:w:c:t:-: arguments; do
  case $arguments in
    w )  W="$OPTARG" ;;
    o )  OUTDIR="$OPTARG" ;;
    t )  TIME="$OPTARG" ;;
    c )  CHANNELS="$OPTARG" ;;
    - )  LONG_OPTARG="${OPTARG#*=}"
         case $OPTARG in
           nolog    )  NO_LOG=true ;;
           nolog* )
                       echo "No arg allowed for --$OPTARG option" >&2; exit 2 ;;
	   noscreen    )  NO_SCREEN=true ;;
           noscreen* )
                       echo "No arg allowed for --$OPTARG option" >&2; exit 2 ;;
           '' )        break ;; # "--" terminates argument processing
           * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
         esac ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ ${NO_LOG} != true ] ;
then
	status="--enable_status=1 --enable_status=2 --enable_status=4 --enable_status=8 --enable_status=16"
fi

if [ "${OUTDIR}" != "" ] ; then mkdir -p ${OUTDIR}; fi
if [ "${OUTDIR: -1}" != "/" ]; then OUTDIR="${OUTDIR}/"; fi

if [ ${NO_SCREEN} != true ] ;
then
screen -dmS wlan${W} hcxdumptool -i wlan${W} -t ${TIME} -o ${OUTDIR}o.cap -O ${OUTDIR}O.cap -W ${OUTDIR}W.cap -c ${CHANNELS} ${status}
sleep 5
screen -ls
else
hcxdumptool -i wlan${W} -t ${TIME} -o ${OUTDIR}o.cap -O ${OUTDIR}O.cap -W ${OUTDIR}W.cap -c ${CHANNELS} ${status}
fi


