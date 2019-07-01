#! /bin/bash
#
# chk_srt.sh
#
# check whether movie file (any extension) has a corresponding
# srt transcription file
#
# Note: printf is required to keep track of multiple blanks in file name
#       echo would squeeze multiple blanks into one blank

MY_PROG=$( basename $0 )

if [ $# -eq 0 ]; then
    echo "Usage: $MY_PROG <directory>"
    exit 0
fi


EXT=${EXT:='\.srt'}
MY_MSG=${MY_MSG="SRT FILE NOT FOUND:"}
ADD_PATH=${ADD_PATH=0}



function version()
{
   (
     echo "$MY_PROG (V1.0: 01-Jul-2019)"
     echo "bash script by hpauluss"
   ) >&2
   exit 0
}

function usage()
{
   (
      echo -e "Usage:      Search for transcription files\n"
      echo -e 'Call:       '$MY_PROG' [-options] <DIRECTORY>\n'
      echo -e "Options:    -h: help\n"

   ) >&2
   exit 0
}

# process options
while getopts "hv" opt; do
   case $opt in
     h ) usage; exit 0 ;;
     v ) version; exit 0 ;;
     * ) usage; exit 1 ;;
   esac
done
shift $(($OPTIND - 1))

DIR_MOVIES=$1

if [ ! -d "$DIR_MOVIES" ]; then
  echo ERROR: directory NOT FOUND: $DIR_MOVIES
  exit 1
fi

for d in $DIR_MOVIES/*;
do

  if [ ! -d "$d" ]; then
     echo ERROR: directory NOT FOUND: $d
     exit 1
  fi

  find "$d" -type f | 
  grep -v "$EXT" | 
  while read f; 
  do 
    f2=$( printf '%s' "${f}" | sed "s/....$/$EXT/" )
#    printf '=== %s\n' "${f2}";
    if [ ! -f "${f2}" ]; then 
      if [ "$ADD_PATH" == 1 ]; then
        printf "%s %s\n" "$MY_MSG" "${f2}"
      else
        printf "%s %s\n" "$MY_MSG" "$( basename "${f2}" )"
      fi
    fi;     	
  done
done 

exit 0


