#!/bin/bash
	
imap_fetch "$Sanityuser" "1:3" "flags"
summary "IMAP:TC_fetch_range_message_flags" $Result