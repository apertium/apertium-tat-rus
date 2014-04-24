#!/bin/bash

# A wrapper sccript to run the testvoc.
# Usage: [TMPDIR=...] ./testvoc.sh

if [ -z $TMPDIR ]; then
	TMPDIR="/tmp"
fi

export TMPDIR

echo "==Tatar->Russian==========================="
bash inconsistency.sh tat-rus > $TMPDIR/tat-rus.testvoc
bash inconsistency-summary.sh $TMPDIR/tat-rus.testvoc tat-rus
