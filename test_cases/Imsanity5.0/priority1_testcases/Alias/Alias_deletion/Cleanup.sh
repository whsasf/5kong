#!/bin/bash

#unset keys:

set_config_keys "/*/common/loginAliases" "false"

#delete test acocunt

account_delete_fn $Sanityuser


