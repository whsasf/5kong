#!/bin/bash
#restore quota settings
set_config_keys "/*/common/mailFolderQuotaEnabled" "false" "1"
set_config_keys "/*/mxos/ldapCosCachingEnabled" "true" "0"
#delete account
account_delete_fn $Sanityuser
