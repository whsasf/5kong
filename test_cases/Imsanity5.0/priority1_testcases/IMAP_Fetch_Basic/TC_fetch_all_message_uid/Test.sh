#!/bin/bash

imap_fetch "$Sanityuser" "1:*" "uid"     
summary "IMAP:TC_fetch_all_message_uid" $Result