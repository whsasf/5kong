#!/bin/bash


imdbcontrol SetAccountStatus $Sanityuser ${default_domain} A > sac.tmp
echo "========== the content of sac.tmp ==========" >>debug.log
cat 		sac.tmp >>debug.log
echo "============================================" >>debug.log						
msg_sh=$(imdbcontrol gaf $Sanityuser ${default_domain} | grep "Status" | cut -d ":" -f2| grep "A" | wc -l)
echo "########## msg_sh=$msg_sh" >>debug.log		
if [ "$msg_sh" == "1" ]
then
			prints "Mode is reset to A" "setaccount_status" "2"
			Result=0
else									
  		prints "ERROR:Mode is not reset to A" "setaccount_status" "1"
  		Result=1									
fi
summary "Account_Mode:Mode_M_change_to_A" $Result
