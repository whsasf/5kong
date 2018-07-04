#!/bin/bash
set_config_keys "/*/mxos/returnUserNameWithDomain" "false"
#unshare folder
unshareFolder "$mxoshost_port" "$Sanityuser1" "$Sanityuser2"  "New_folder"
#delete test acocunt
account_delete_fn $Sanityuser2
account_delete_fn $Sanityuser1

