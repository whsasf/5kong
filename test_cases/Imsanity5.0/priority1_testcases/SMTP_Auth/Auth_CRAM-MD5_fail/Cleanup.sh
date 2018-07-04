#!/bin/bash

#set keys:
set_config_keys "/*/mta/requireAuthentication" "false"
set_config_keys "/inbound-standardmta-direct/mta/requireAuthentication" "false"
set_config_keys "/*/mta/allowCRAMMD5" "false"
#delete test acocunt
account_delete_fn $Sanityuser

rm modify.ldif


#revert cram-md5.py
sed -i '1d' cram-md5.py
sed -i "1i\#!/usr/bin/python"  cram-md5.py
