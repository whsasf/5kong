#!/bin/bash
> debug.log
> summary.log

#delete account 
show_defaultcos
summary "COS:TC_show_defaultcos" $Result

cat debug.log   >> $debuglog
cat summary.log >> $summarylog
