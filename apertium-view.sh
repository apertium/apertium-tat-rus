#!/bin/bash

ARGS=$(getopt "uad:" $*);
set -- $ARGS;
for i; do
  case "$i" in 
    -d) shift; DIRECTORY=$1; shift;;
    -u) UWORDS="no"; shift;;
    -a) OPTION_TAGGER="-m"; shift;;
    --) shift; break;;
  esac;
done;
if [ "$UWORDS" = "no" ]; then OPTION="-n"; else OPTION="-g"; fi;

case "$#" in 
     1) PAIR=$1;;
     *) echo 'error'; exit;;
esac;

TEEMODE=`mktemp teemode.XXXXXXXX`;
MODE=$DIRECTORY/modes/$1.mode;
i=1;
tr '|' '\n' < "$MODE" | grep -v '^\s*$' | while read cmd;
do
    if [ $i -ne 1 ]; then echo -n "|"; fi
    echo -n $cmd " | tee /tmp/apertium-view-$i.out " ;
    (( i = $i + 1 ));
done > "$TEEMODE";
echo '' >> $TEEMODE;

# Run translation:
bash "$TEEMODE" $OPTION $OPTION_TAGGER >/dev/null;

# Print all stages:
tr '|' '\n' < "$TEEMODE" | sed "s/\$1/$OPTION/
s/\$2/$OPTION_TAGGER/" |\
awk -F'tee ' '# Every other line should be a tee, then a command
/tee \/tmp\/apertium-view-/ {while(("cat "$2 | getline line)>0){print line;};print ""; next}
//                          {$0="| "$0" |"; 
                             s=sprintf("%"length($0)"s","");gsub(" ","_",s);print s; # pretty
                             print;
                             s=sprintf("%"length($0)"s","");gsub(" ","‾",s);print s; # pretty
			     }' 


rm -f "$TEEMODE";

