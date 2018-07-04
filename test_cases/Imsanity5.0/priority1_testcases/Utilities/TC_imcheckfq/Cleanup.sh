#!/bin/bash
#restore quota settings
imdbcontrol SetCosAttribute default mailFolderQuota  "/ all,ageweeks,5"
#unset key
set_config_keys "/*/common/mailFolderQuotaEnabled" "false" "1"
#delete account
account_delete_fn $Sanityuser
