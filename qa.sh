# Takes the test name in /tests as an argument, an additional argument
# if the test requires it (e.g. corpus name) and runs the test.

#!/bin/bash

bash "tests/$1.test"

