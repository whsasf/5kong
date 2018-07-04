#!/bin/bash

imboxstats_fn $Sanityuser
cc=$Result
currentcount1=$(grep "Total Messages Stored" log_imboxstats.tmp |awk -F ":" '{print $2}')
currentcount1=$(echo $currentcount1 | tr -d " ") 
echo "########## currentcount1=$currentcount1" >>debug.log
mail_send $Sanityuser "small" "1"
imboxstats_fn $Sanityuser
let cc=cc+Result
currentcount2=$(grep "Total Messages Stored" log_imboxstats.tmp |awk -F ":" '{print $2}')
currentcount2=$(echo $currentcount2 | tr -d " ") 	
echo "########## currentcount2=$currentcount2"  >>debug.log
let a=currentcount2-currentcount1
echo "########## cc=$cc"  >>debug.log
echo "########## a=$a"  >>debug.log

if [ "$cc" == "0" -a "$a" == "1" ];then
	Result=0
else
  Result=1
fi
summary "UTILITIES:TC_imboxstats" $Result