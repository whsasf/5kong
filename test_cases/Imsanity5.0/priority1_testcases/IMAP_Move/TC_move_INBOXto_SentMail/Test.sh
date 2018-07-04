#!/bin/bash
imap_move "$Sanityuser" "2" "SentMail" "INBOX"
	
summary "IMAP:TC_move_INBOXto_SentMail" $Result
