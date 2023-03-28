#! /bin/bash
#
# getAudioSize.sh
#
# get time of audio file
#
# This version is used for MacOS


#####
# INIT 1
#####

OLDPATH=$( pwd )
PROGNAME=$(basename $0)


#####
# SUBROUTINES
#####

function usage() {

    # Display usage message on standard error
    printf "Usage: %s <AUDIO_FILE>\n" $PROGNAME
    printf "Option: -h help\n"
    printf "        -v version\n\n"
    
} 1>&2 # usage


function version()
{
   (
     echo "$PROGNAME (V1.01: 13-Mar-2023)"
     echo "bash script by HPA"
   ) >&2
   exit 0
} # version



#####
# INIT 2
#####


# process options
while getopts ":d:hv" opt; do
   case $opt in
     h ) usage; exit 0 ;;
     v ) version >&2 ;;
     * ) ;;
   esac
done
shift $(($OPTIND - 1))

if [ "$#" -lt 1 ]; then
    usage
    exit 1;
fi

AUDIO_FILE=$1

if [ ! -f "$AUDIO_FILE" ]; then
    echo "ERROR: ${PROGNAME}: File not available '$AUDIO_FILE'"
    exit 1
fi

FILE_TYPE=$( file -b "$AUDIO_FILE" )

isTEXT=$( echo "$FILE_TYPE" | grep -i "text" )

if [ ! -z "$isTEXT" ]; then
    echo "ERROR: ${PROGNAME}: Probably not an audio file: '$AUDIO_FILE'";
    exit 1
fi


#####
# MAIN
#####


TMP_AUDIO=/tmp/tmp-audio-time.txt
rm -f $TMP_AUDIO

# -nostdin necessary on MacOS
ffmpeg -nostdin -v quiet -stats -i "$AUDIO_FILE"  -f null - > $TMP_AUDIO 2>&1 &&
audioTIME=$( cat "$TMP_AUDIO" | tr ' ' '\n' |
             grep time= | tail -1 | sed 's/time=//' )

# Example: size=N/A time=00:43:48.06 bitrate=N/A speed=1.76e+03x
printf "%s\t%s\n" "${AUDIO_FILE##*/}" $audioTIME

exit 0

