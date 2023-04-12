#! /bin/bash
#
# mp3-concat.sh
#
# Inspired by
# https://askubuntu.com/questions/20507/concatenating-several-mp3-files-into-one-mp3/1315120#1315120


#####
# INIT 1
#####

PROGNAME=$(basename $0)
MPG_123=$( which mpg123 )


#####
# INIT 2
#####

function usage() {

    # Display usage message on standard error
    printf "Usage: %s <MP3> <MP3>...\n" $PROGNAME
    printf "       MP3 files are concatinated.\n"
    printf "       Output is sent to standard output\n\n"
    printf "Option: -h help\n"
    printf "        -v version\n"
    
} 1>&2 # usage


function version()
{
   (
     echo "$PROGNAME (V1.02: 12-Apr-2023)"
     echo "bash script by HPA"
   ) >&2
   exit 0
} # version


function do_mpg123()
{
    
    FILES=("$@")
    OUTPUT=$(mktemp -t mp3-concat.XXXXXX.mp3 -u)
    WAVE=$(mktemp -t mp3-concat.XXXXXX.wav -u)
    mpg123 -w $WAVE ${FILES[@]}
    lame $WAVE $OUTPUT
    cat $OUTPUT
   
} # do_mpg123


#####
# INIT 2
#####


# process options
while getopts "hv" opt; do
    case $opt in
     h ) usage; exit 0 ;;
     v ) version >&2 ;;
     * ) ;;
   esac
done
shift $(($OPTIND - 1))

echo Number of arguments: $#

if [ "$#" -lt 2 ]; then
    echo ERROR: ${PROGNAME}: 2 MP3 files required
    exit 1
fi

if [ -z "$MPG_123" ]; then
    echo ERROR: ${PROGNAME}: 'program "mpg123" not available'
    exit 1
fi


#####
# MAIN
#####

do_mpg123

exit 0

