#!/bin/bash
imap_copy "$Sanityuser" "2" "new1" "INBOX"
		
summary "IMAP:TC_copy_INBOX_customfolder" $Result
