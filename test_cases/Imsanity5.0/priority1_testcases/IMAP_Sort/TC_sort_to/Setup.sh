#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc


#create test actest$(echo $RANDOM)count
Sanityuser=test$(echo $RANDOM)
account_create_fn $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi

immsgdelete $Sanityuser@${default_domain} -all 

#create headers
create_headerfiles
#deliever 8 messages

for ((i=1;i<=8;i++))
do
  datalength=$(wc -c header$i.tmp |awk  '{print $1}')
  DATA=$(cat header$i.tmp)
	imap_append "$Sanityuser" "INBOX" "{$datalength}" "$DATA"
done
imboxstats_fn $Sanityuser


