#!/bin/bash
	
imap_fetch "$Sanityuser" "1:2,3:3" "body[header]"
summary "IMAP:TC_fetch_option1_message_body_header" $Result