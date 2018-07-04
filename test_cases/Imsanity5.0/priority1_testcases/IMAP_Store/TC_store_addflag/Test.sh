#!/bin/bash
imap_store "$Sanityuser" "1" "+" "\Draft" "INBOX"	
summary "IMAP:TC_store_addflag" $Result
