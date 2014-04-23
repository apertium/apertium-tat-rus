#! /bin/bash

if [ -z $TMPDIR ]; then
	TMPDIR="/tmp"
fi

echo "==Tatar->Russian===========================";
bash inconsistency.sh tat-rus > $TMPDIR/tat-rus.testvoc; bash inconsistency-summary.sh $TMPDIR/tat-rus.testvoc tat-rus
