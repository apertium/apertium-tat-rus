#!/bin/bash

# A script to run the standard (=full) testvoc.
#
# Assumes the pair is compiled.
# Expands the source language dictionary/transducer MONODIX and passes the
# result of the expansion through the translator (=inconsistency.sh script).
# Produces 'testvoc-summary.tat-rus.txt' file using the inconsistency-summary.sh.
#
# Usage: [TMPDIR=/path/to/tmpdir] ./testvoc.sh

if [ -z $TMPDIR ]; then
	TMPDIR="/tmp"
fi

export TMPDIR

# With Tatar transducer being trimmed to the bilingual dictionary, it is
# possible to run the full testvoc in a reasonable time (at least now, in the
# beginning, when the bidix is small) *ON ONE CONDITION* -- we do not include
# (cyclic) digits stuff in the .deps/tat-rus.automorf.trimmed.
# In order to trim them, we have to comment out the following line in tat-rus.dix
# <e>       <re>[№%]?[0-9]+([.,][0-9]+)*[.,]*</re><p><l><s n="num"/></l><r> ...
# and then compile:
cd ../../
sed -i 's_^<e>       <re>\[№.*$_<!--&-->_' apertium-tat-rus.tat-rus.dix
make
cd testvoc/standard/

function expand_monodix {
    hfst-fst2strings $MONODIX | sort -u | cut -d':' -f2 | \
    sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g'
}

#-------------------------------------------------------------------------------
# Tatar->Russian testvoc
#-------------------------------------------------------------------------------

MONODIX=../../.deps/tat-rus.automorf.trimmed

echo "==Tatar->Russian==========================="

expand_monodix |
bash inconsistency.sh tat-rus > $TMPDIR/tat-rus.testvoc
bash inconsistency-summary.sh $TMPDIR/tat-rus.testvoc tat-rus
