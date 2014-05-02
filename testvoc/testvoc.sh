#!/bin/bash

# A wrapper script to run the testvoc.
# Usage: [TMPDIR=...] ./testvoc.sh

if [ -z $TMPDIR ]; then
	TMPDIR="/tmp"
fi

export TMPDIR

# With Tatar transducer being trimmed to the bilingual dictionary, it is
# possible to run the full testvoc in a reasonable time (at least now in the
# beginning, when the bidix is small) *under one condition* -- we do not include
# (cyclic) digits stuff in the .deps/tat-rus.automorf.trimmed. In order to trim
# them, we have to get rid from the following line in tat-rus.dix:
# <e>       <re>[№%]?[0-9]+([.,][0-9]+)*[.,]*</re><p><l><s n="num"/></l><r><s n="num"/><s n="digit"/></r></p></e>
# and then compile.

echo "==Tatar->Russian==========================="
bash inconsistency.sh tat-rus > $TMPDIR/tat-rus.testvoc
bash inconsistency-summary.sh $TMPDIR/tat-rus.testvoc tat-rus
