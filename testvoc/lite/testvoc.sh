#!/bin/bash

# A script to run the "lite" ("one-word-per-each-paradigm-") testvoc.
#
# Assumes the pair is compiled.
# Extracts lexical units from text files in languages/apertium-tat/tests/
# morphotactics/ and passes them through the translator (=INCONSISTENCY script).
# Generates a one-line stats about each file using the INCONSISTENCY-SUMMARY
# script and produces 'testvoc-summary.tat-rus.txt' file.
#
# Usage: [TMPDIR=/path/to/tmpdir] ./testvoc.sh

INCONSISTENCY=../standard/./inconsistency.sh
INCONSISTENCY_SUMMARY=./inconsistency-summary.sh

if [ -z $TMPDIR ]; then
	TMPDIR="/tmp"
fi

export TMPDIR

function extract_lexical_units {
    sort -u | cut -f2 -d':' | \
    sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g'
}

echo "==Tatar->Russian==========================="

PARDEF_FILES=../../../../languages/apertium-tat/tests/morphotactics/*.txt
OUT=testvoc-summary.tat-rus.txt

echo "" > $OUT
date >> $OUT
$ECHOE  "===============================================" >> "$OUT"
$ECHOE  "POS\tTotal\tClean\tWith @\tWith #\tClean %" >> "$OUT"
for file in $PARDEF_FILES; do
    cat $file | extract_lexical_units |
    $INCONSISTENCY tat-rus
done
