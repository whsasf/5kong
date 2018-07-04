#!/bin/bash
account_create_fn  test1

imboxstats test1@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn test1
fi

summary "UTILITIES:TC_account_create" $Result