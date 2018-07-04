#!/bin/bash


imboxstats $Sanityuser@${default_domain} > boxstats.tmp
echo "========== the content of boxstats.tmp ==========" >>debug.log
cat boxstats.tmp>>debug.log
echo "=================================================" >>debug.log
msgs_user=$(grep "Total Messages Stored"  boxstats.tmp | cut -d ":" -f2)
msgs_user=`echo $msgs_user | tr -d " "`
echo "########## msgs_user=$msgs_user" >>debug.log
if [ $msgs_user -gt 0 ]
then
    prints " Mail is delivered successfully" "ITS_1319590" 2
   	
    msgid=$(grep "Message-ID" msgdump.tmp|awk -F "=" '{print $2}'|tr -d " ")
    echo "########## msgid=$msgid"  >>debug.log
   	immsgdelete_utility $Sanityuser $msgid					
	  
else
    prints " Mail is delivered unsuccessfully" "ITS_1319590"  1
    Result=1
fi							  
summary "UTILITIES:TC_immsgdelete_single_message"  $Result