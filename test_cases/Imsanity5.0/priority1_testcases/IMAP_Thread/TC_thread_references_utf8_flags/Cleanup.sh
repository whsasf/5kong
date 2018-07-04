#!/bin/bash

#unset keys
set_config_keys "/*/imapserv/enableTHREAD" "false" 1 	
set_config_keys "/*/mss/ConversationViewEnabled" "false" 1

#delete test acocunt
account_delete_fn $Sanityuser

