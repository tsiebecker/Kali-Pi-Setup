#!/bin/bash

INFILE="";
OUTDIR="";

while getopts i:o: arguments; do
  case $arguments in
    i )  INFILE="$OPTARG" ;;
    o )  OUTDIR="$OPTARG" ;;
    \? ) exit 2 ;;  # getopts already reported the illegal option
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list

if [ "${OUTDIR}" != "" ] ; then mkdir ${OUTDIR}; fi
if [ "${OUTDIR: -1}" != "/" ]; then OUTDIR="${OUTDIR}/"; fi

hcxpcaptool -o ${OUTDIR}o -O ${OUTDIR}O -z ${OUTDIR}z -j ${OUTDIR}j -J ${OUTDIR}J -E ${OUTDIR}E -I ${OUTDIR}I -U ${OUTDIR}U -P ${OUTDIR}P -T ${OUTDIR}T -g ${OUTDIR}g --netntlm-out=${OUTDIR}netntlm-out --md5-out=${OUTDIR}md5-out --md5-john-out=${OUTDIR}md5-john-out --tacacsplus-out=${OUTDIR}tacacsplus-out --eapol-out=${OUTDIR}eapol-out --network-out=${OUTDIR}network-out --hexdump-out=${OUTDIR}hexdump-out --hccap-out=${OUTDIR}hccap-out --hccap-raw-out=${OUTDIR}hccap-raw-out --nonce-error-corrections=128 -V ${INFILE}

:<<'multiline_comment'
hcxpcaptool 5.1.1 (C) 2019 ZeroBeat
usage:
hcxpcaptool <options>
hcxpcaptool <options> [input.pcap] [input.pcap] ...
hcxpcaptool <options> *.cap
hcxpcaptool <options> *.*

options:
-o <file> : output hccapx file (hashcat -m 2500/2501)
-O <file> : output raw hccapx file (hashcat -m 2500/2501)
-z <file> : output PMKID file (hashcat hashmode -m 16800)
-j <file> : output john WPAPSK-PMK file (john wpapsk-opencl)
-J <file> : output raw john WPAPSK-PMK file (john wpapsk-opencl)
-E <file> : output wordlist (autohex enabled) to use as input wordlist for cracker
-I <file> : output unsorted identity list
-U <file> : output unsorted username list
-P <file> : output possible WPA/WPA2 plainmasterkey list
-T <file> : output management traffic information list
          : european date : timestamp : mac_sta : mac_ap : essid
-g <file> : output GPS file
            format = GPX (accepted for example by Viking and GPSBabel)
-V        : verbose (but slow) status output
-h        : show this help
-v        : show version

--time-error-corrections=<digit>  : maximum allowed time gap (default: 600s)
--nonce-error-corrections=<digit> : maximum allowed nonce gap (default: 8)
                                  : should be the same value as in hashcat
--netntlm-out=<file>              : output netNTLMv1 file (hashcat -m 5500, john netntlm)
--md5-out=<file>                  : output MD5 challenge file (hashcat -m 4800)
--md5-john-out=<file>             : output MD5 challenge file (john chap)
--tacacsplus-out=<file>           : output TACACS+ authentication file (hashcat -m 16100, john tacacs-plus)
--eapol-out=<file>                : output EAPOL packets in hex
                                    format = mac_ap:mac_sta:EAPOL
--network-out=<file>              : output network information
                                    format = mac_ap:ESSID
--hexdump-out=<file>              : output dump raw packets in hex
--hccap-out=<file>                : output old hccap file (hashcat -m 2500)
--hccap-raw-out=<file>            : output raw old hccap file (hashcat -m 2500)
--help                            : show this help
--version                         : show version

bitmask for message pair field:
0: MP info (https://hashcat.net/wiki/doku.php?id=hccapx)
1: MP info (https://hashcat.net/wiki/doku.php?id=hccapx)
2: MP info (https://hashcat.net/wiki/doku.php?id=hccapx)
3: x (unused)
4: ap-less attack (set to 1) - no nonce-error-corrections neccessary
5: LE router detected (set to 1) - nonce-error-corrections only for LE neccessary
6: BE router detected (set to 1) - nonce-error-corrections only for BE neccessary
7: not replaycount checked (set to 1) - replaycount not checked, nonce-error-corrections definitely neccessary

Do not use hcxpcaptool in combination with third party cap/pcap/pcapng cleaning tools (except: tshark and/or Wireshark)!
multiline_comment
