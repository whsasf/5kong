#!/bin/bash

#disable condstore
echo "disable condstore............."
set_config_keys "/*/common/enableCONDSTORE" "false"  "1"
sleep 3

set_config_keys "/*/imboxmaint/clusterName" ""

#delete acocunt
account_delete_fn $Sanityuser
