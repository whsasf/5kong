#!/bin/bash


#create accpunt based on new cos:bogus 
Sanityuser=test1
account_create_fn $Sanityuser bogus
imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
echo "========== the content of accountexist.tmp ==========" >>debug.log
cat accountexist.tmp >>debug.log
echo "=====================================================" >>debug.log
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
echo "########## ec=$ec" >>debug.log 
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser  bogus
fi

#curl -s -X GET "http://172.26.202.245:8081/mxos/mailbox/v2/$Sanityuser@${default_domain}" |jq .
summary "COS:TC_create_newaccount_using_new_COS" $Result
