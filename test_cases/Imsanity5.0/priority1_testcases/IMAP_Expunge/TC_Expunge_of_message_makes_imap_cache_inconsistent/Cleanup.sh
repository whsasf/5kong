#!/bin/bash
#disable imap trace
set_config_keys "/*/common/traceOutputLevel" "" "0" 
#delete test acocunt
account_delete_fn $Sanityuser

