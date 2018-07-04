#!/bin/bash
imap_rename "$Sanityuser" "inbox" "new_Inbox"
summary "IMAP:TC_rename_systemfolder_customfolder_Inbox" $Result
