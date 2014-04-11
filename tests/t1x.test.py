#!/bin/env python2.7

## The purpose of this program is to make sure that the transfer rules in
## tat-rus.t1x do the job they advertise in their headers with INPUT/OUTPUT
## comments.
##
## In particular, the program does the following:
##    * takes all the INPUT statements from the apertium-tat-rus.tat-rus.t1x file
##    * runs them through 'apertium-transfer -b -t apertium-tat-rus.tat-rus.t1x
##      tat-rus.t1x'
##    * checks whether the output of apertium-transfer matches with the
##      corresponding OUTPUT statements (and because of the rule #X the test case
##      was written for)
##    * if all tests pass, it prints a message to that regard
##    * otherwise it prints line numbers of rules and INPUT statements which
##      didn't pass.

 
## Here is a snippet from the actual transfer rule file which shows how the
## INPUT/OUTPUT statements look like:
##
## <!--
## INPUT:  ^и<cop><p3><sg>/быть<vbser><p3><sg>$
## OUTPUT: ^cop-pres<VBSER>{^быть<vbser><pres><p3><sg>$}$
## -->
##     <rule comment="">
##       <pattern>
##         <pattern-item n="cop-pres"/>
##       </pattern>
##       <action>
##          ...
##
## TODO: probably better to put them in the rule body (either in the <rule
## comment=""> or at least after the <rule> tag).


## We represent test cases as a list of tuples. Each tuple consists of four things:
## (line number of the <rule>, 
## line number of the INPUT statement, 
## INPUT statement for the transfer module, 
## expected OUTPUT of the transfer module).


## WISHLIST
## ========
##
## 1. A function to parse the t1x file and extract test cases from it.
##      Returns a list of tuples described above.
## 2. A function to iterate over the elements of this list and feed each each
##      INPUT statement into transfer module.
##      Prints the result of each iteration into STDOUT.
##      Returns a list of tuples in the form of: 
##      (line # of the <rule>, line # of the not-passing INPUT statement).
## 3. A main function that makes use of function (1) and function (2).
##      Prints a message about the results of the tests.

