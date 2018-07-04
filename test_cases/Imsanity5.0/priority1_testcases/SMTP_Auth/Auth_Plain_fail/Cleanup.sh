#!/bin/bash

#set keys:
set_config_keys "/*/mta/requireAuthentication" "false"
set_config_keys "/inbound-standardmta-direct/mta/requireAuthentication" "false"

#delete test acocunt
account_delete_fn $Sanityuser
rm modify.ldif

