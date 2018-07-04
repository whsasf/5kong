#!/bin/bash

#unset keys:

set_config_keys "/*/common/loginAliases" "false"

#delet aliass
delete_alias 2 $Sanityuser plus2 minus2 multiply2 divide2
#delete test acocunt

account_delete_fn $Sanityuser

