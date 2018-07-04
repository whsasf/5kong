#!/bin/bash
imap_copy "$Sanityuser" "2" "Trash" "INBOX"
summary "IMAP:TC_copy_INBOXto_Trash" $Result
