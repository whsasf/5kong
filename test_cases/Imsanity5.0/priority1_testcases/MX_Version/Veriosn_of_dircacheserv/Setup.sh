#!/bin/bash
> debug.log
> summary.log
start_time_tc
#Result=1_by_fefault
Result=1
dircache1=$(imconfget oPWVDirVersion)
echo "########## dircache1=$dircache1"  >>$debuglog
