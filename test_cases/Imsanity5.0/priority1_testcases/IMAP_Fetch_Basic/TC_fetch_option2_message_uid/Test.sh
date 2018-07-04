#!/bin/bash
	
imap_fetch "$Sanityuser" "1:2,3" "uid"     
summary "IMAP:TC_fetch_option2_message_uid" $Result