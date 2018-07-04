#!/bin/bash
imap_store "$Sanityuser" "1" "+" "\TEMP" "INBOX"
	
summary "IMAP:TC_store_add_invalidflag" $Result
