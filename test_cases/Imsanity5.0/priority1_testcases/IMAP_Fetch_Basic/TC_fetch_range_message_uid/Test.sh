#!/bin/bash
	
imap_fetch "$Sanityuser" "1:3" "uid"    
summary "IMAP:TC_fetch_range_message_uid" $Result