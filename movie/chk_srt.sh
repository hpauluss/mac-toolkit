#! /bin/bash
#
# chk_srt.sh
#
# check whether movie file (any extension) has a corresponding
# srt transcription file

DIR_MOVIES=/tmp/test_module/
EXT='\.srt'
MY_MSG="SRT FILE NOT FOUND:"
ADD_PATH=0

for d in $DIR_MOVIES/a/*;
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


