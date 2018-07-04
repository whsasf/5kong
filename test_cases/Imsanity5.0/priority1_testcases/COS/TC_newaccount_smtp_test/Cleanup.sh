#!/bin/bash
#delete account 
account_delete_fn $Sanityuser
#delete COS
delete_cos bogus
#restore key
set_config_keys "/*/mss/realmsLocal"  ""  "1"
