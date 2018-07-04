#!/bin/bash
imap_copy "$Sanityuser" "1" "SentMail" "Trash" 
summary "IMAP:TC_copy_Trashto_SentMail" $Result
