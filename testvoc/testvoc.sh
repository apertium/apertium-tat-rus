#!/bin/bash

# A wrapper script to run the testvoc.
# Usage: [TMPDIR=/path/to/tmpdir] ./testvoc.sh
# Assumes the pair is compiled.
# Produces 'testvoc-summary.tat-rus.txt' file.

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
cd ..
sed -i 's_^<e>       <re>\[№.*$_<!--&-->_' apertium-tat-rus.tat-rus.dix
make
cd testvoc/

echo "==Tatar->Russian==========================="
bash inconsistency.sh tat-rus > $TMPDIR/tat-rus.testvoc
bash inconsistency-summary.sh $TMPDIR/tat-rus.testvoc tat-rus
