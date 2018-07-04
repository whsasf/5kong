#!/bin/bash

#unset keys:

set_config_keys "/*/common/loginAliases" "false"

#delete alias
delete_alias 1 $Sanityuser plus1

#delete test acocunt

account_delete_fn $Sanityuser



