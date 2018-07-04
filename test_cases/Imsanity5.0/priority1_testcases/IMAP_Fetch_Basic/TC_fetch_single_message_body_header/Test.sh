#!/bin/bash

            
imap_fetch "$Sanityuser" "1" "body[header]"
summary "IMAP:TC_fetch_single_message_body_header" $Result