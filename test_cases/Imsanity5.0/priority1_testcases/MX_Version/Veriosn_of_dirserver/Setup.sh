#!/bin/bash
start_time_tc
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
dir1=$(imconfget oPWVDirVersion)
echo "########## dir1=$dir1" >>$debuglog
