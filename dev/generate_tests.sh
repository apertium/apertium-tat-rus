#!/bin/bash

# Read lines in the form 'TatarSurfaceForm:RussianSursfaceForm' from stdin,
# and output 'TatarSurfaceForm:TatarLexcialForms:RussianLexicalForm:RussianSurfaceForm
# to stdout.

SL_ANALYZER="lt-proc tat-rus.automorf.bin"
TL_ANALYZER="lt-proc ../../languages/apertium-rus/rus.automorf.bin"

while IFS=':' read slSurf tlSurf
do
    slLex=$(echo $slSurf | $SL_ANALYZER | cut -s -d'/' -f 2-)
    tlLex=$(echo $tlSurf | $TL_ANALYZER | cut -s -d'/' -f 2-)
    echo "$slSurf:$slLex:$tlLex:$tlSurf"
done
