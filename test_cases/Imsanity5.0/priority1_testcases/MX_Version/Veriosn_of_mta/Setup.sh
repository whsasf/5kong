#!/bin/bash
start_time_tc
msg_msg_ver2=$(imdbcontrol -version | grep -i version | cut -d " " -f2)
msg_msg_ver3=$(imdbcontrol -version | grep -i version | cut -d " " -f3)					
#Result=1_by_fefault
Result=1
msg_msg_ver="$msg_msg_ver2 $msg_msg_ver3"
echo  "########## msg_msg_ver=$msg_msg_ver"  >> $debuglog