#!/bin/bash
#unshare folder
unshareFolder "$mxoshost_port" "$Sanityuser1" "$Sanityuser2"  "Trash"
#delete test acocunt
account_delete_fn $Sanityuser1
account_delete_fn $Sanityuser2
