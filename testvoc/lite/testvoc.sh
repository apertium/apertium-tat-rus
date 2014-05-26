#!/bin/bash

# A script to run the "lite" ("one-word-per-each-paradigm-") testvoc.
#
# Assumes the pair is compiled.
# Extracts lexical units from compressed text files in languages/apertium-tat/
# tests/morphotactics/ and passes them through the translator (=INCONSISTENCY
# script).
# Produces 'testvoc-summary.tat-rus.txt' file using the INCONSISTENCY_SUMMARY script.
#
# TODO: Generate stats about each file (e.g. N1.txt), not just about the category (e.g. nouns).
#
# Usage: [TMPDIR=/path/to/tmpdir] ./testvoc.sh

INCONSISTENCY=../standard/./inconsistency.sh
INCONSISTENCY_SUMMARY=../standard/./inconsistency-summary.sh

if [ -z $TMPDIR ]; then
	TMPDIR="/tmp"
fi

export TMPDIR

function extract_lexical_units {
    sort -u | cut -f2 -d':' | \
    sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g'
}

#-------------------------------------------------------------------------------
# Tatar->Russian testvoc
#-------------------------------------------------------------------------------

PARDEF_FILES=../../../../languages/apertium-tat/tests/morphotactics/*.txt.gz

echo "==Tatar->Russian==========================="

echo "" > $TMPDIR/tat-rus.testvoc

for file in $PARDEF_FILES; do
    zcat $file | extract_lexical_units |
    $INCONSISTENCY tat-rus >> $TMPDIR/tat-rus.testvoc
done

$INCONSISTENCY_SUMMARY $TMPDIR/tat-rus.testvoc tat-rus
