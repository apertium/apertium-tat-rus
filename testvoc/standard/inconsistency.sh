#!/bin/bash

# Passes its input -- a list of lexical units -- through the translator
# (transfer modules and target language generator).
# Creates three text files in TMPDIR:
#     1) INPUT, a list of lexical units taken
#     2) TRANSFOUT, this list after passing transfer modules
#     3) GENOUT, this list after TL generator.
# Outputs "paste INPUT TRANSFOUT GENOUT"
# Supposed to be invoked by ./testvoc.sh, and not run directly.

if [ -z $TMPDIR ]; then
	TMPDIR="/tmp"
fi

INPUT=$TMPDIR/testvoc_input.txt
TRANSFOUT=$TMPDIR/testvoc_transfout.txt
GENOUT=$TMPDIR/testvoc_genout.txt

DIR=$1

if [[ $DIR = "tat-rus" ]]; then

    BIDIXBIN=../../tat-rus.autobil.bin
    T1X=../../apertium-tat-rus.tat-rus.t1x; T1XBIN=../../tat-rus.t1x.bin
    T2X=../../apertium-tat-rus.tat-rus.t2x; T2XBIN=../../tat-rus.t2x.bin
    T3X=../../apertium-tat-rus.tat-rus.t3x; T3XBIN=../../tat-rus.t3x.bin
    GENERATORBIN=../../tat-rus.autogen.bin

    tee $INPUT |
    apertium-pretransfer |
    apertium-transfer $T1X $T1XBIN $BIDIXBIN |
    apertium-interchunk $T2X $T2XBIN |
    apertium-postchunk $T3X $T3XBIN | tee $TRANSFOUT |
    lt-proc -d $GENERATORBIN > $GENOUT
    paste -d _ $INPUT $TRANSFOUT $GENOUT | 
    sed 's/\^.<sent>\$//g' | sed 's/_/   -->  /g'

else
	echo "./inconsistency.sh <direction>";
fi
