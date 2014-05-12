#!/bin/bash

# This script expands the source language dictionary/transducer MONODIX and
# passes the result of the expansion through the translator.
# It is supposed to be invoked by ./testvoc.sh, and not run directly.

if [ -z $TMPDIR ]; then
	TMPDIR="/tmp"
fi

DIR=$1

function expand_monodix {
    hfst-fst2strings $MONODIX | sort -u | sed 's/:/%/g' | cut -f2 -d'%' | \
    sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g' | tee $TMPDIR/tmp_testvoc1.txt
}

if [[ $DIR = "tat-rus" ]]; then

    MONODIX=../../.deps/tat-rus.automorf.trimmed
    BIDIXBIN=../../tat-rus.autobil.bin
    T1X=../../apertium-tat-rus.tat-rus.t1x; T1XBIN=../../tat-rus.t1x.bin
    T2X=../../apertium-tat-rus.tat-rus.t2x; T2XBIN=../../tat-rus.t2x.bin
    T3X=../../apertium-tat-rus.tat-rus.t3x; T3XBIN=../../tat-rus.t3x.bin
    GENERATORBIN=../../tat-rus.autogen.bin

    expand_monodix |
    apertium-pretransfer |
    apertium-transfer $T1X $T1XBIN $BIDIXBIN |
    apertium-interchunk $T2X $T2XBIN |
    apertium-postchunk $T3X $T3XBIN | tee $TMPDIR/tmp_testvoc2.txt |
    lt-proc -d $GENERATORBIN > $TMPDIR/tmp_testvoc3.txt
    paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt \
	$TMPDIR/tmp_testvoc3.txt | 
    sed 's/\^.<sent>\$//g' | sed 's/_/   --------->  /g'

else
	echo "./inconsistency.sh <direction>";
fi
