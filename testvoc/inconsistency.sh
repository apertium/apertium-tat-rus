#!/bin/bash

# This script expands the source language dictionary/transducer and passes it
# through the translator.
# It is supposed to be invoked by ./testvoc.sh, and not run directly.

DIR=$1

MONODIX=../.deps/tat-rus.automorf.trimmed
BIDIXBIN=../tat-rus.autobil.bin
T1X=../apertium-tat-rus.tat-rus.t1x; T1XBIN=../tat-rus.t1x.bin
T2X=../apertium-tat-rus.tat-rus.t2x; T2XBIN=../tat-rus.t2x.bin
T3X=../apertium-tat-rus.tat-rus.t3x; T3XBIN=../tat-rus.t3x.bin
GENERATORBIN=../tat-rus.autogen.bin

if [[ $DIR = "tat-rus" ]]; then

hfst-fst2strings $MONODIX | sort -u |  sed 's/:/%/g' | cut -f1 -d'%' |  sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g' | tee $TMPDIR/tmp_testvoc1.txt |
        apertium-pretransfer |
        apertium-transfer $T1X $T1XBIN $BIDIXBIN |
        apertium-transfer -n $T2X $T2XBIN |
        apertium-transfer -n $T3X $T3XBIN | tee $TMPDIR/tmp_testvoc2.txt |
        lt-proc $GENERATORBIN > $TMPDIR/tmp_testvoc3.txt
paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt | sed 's/\^.<sent>\$//g' | sed 's/_/   --------->  /g'

else
	echo "./inconsistency.sh <direction>";
fi
