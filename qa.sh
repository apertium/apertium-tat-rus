# Takes the test name in /tests as an argument, an additional argument
# if the test requires it (e.g. corpus name) and runs the test.

#!/bin/bash

if [ $# -eq 0 ]
  then
    testToRun=tat-rus.test
  else
    testToRun=$1.test
fi

bash "tests/$testToRun"

