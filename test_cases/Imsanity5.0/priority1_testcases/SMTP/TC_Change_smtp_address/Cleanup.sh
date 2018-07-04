#!/bin/bash

imdbcontrol mas testuser ${default_domain} $Sanityuser ${default_domain} >> debug.log	

#set keys:

set_config_keys "/*/common/loginAliases" "false"			
#delete test acocunt
account_delete_fn $Sanityuser

