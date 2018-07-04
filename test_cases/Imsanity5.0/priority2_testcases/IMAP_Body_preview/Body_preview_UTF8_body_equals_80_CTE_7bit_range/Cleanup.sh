#!/bin/bash
#delete test acocunt
account_delete_fn $Sanityuser
#body preview key disable	
set_config_keys "/*/common/enableXFIRSTLINE" "false"

