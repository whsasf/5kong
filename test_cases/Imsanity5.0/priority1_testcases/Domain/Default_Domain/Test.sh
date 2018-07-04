#!/bin/bash

msg=$(imdbcontrol GetDefaultDomain |grep "${default_domain}" | wc -l)
echo "########## msg=$msg" >>debug.log
if [ "$msg" == "1" ]
then
	prints "Default domain is ${default_domain}" "default_domain" "2"
	Result="0"
else
	prints "ERROR:Default domain is not ${default_domain}. Please check manually." "default_domain" "1"
	Result="1"
fi
summary "Domain:Default_domain" $Result