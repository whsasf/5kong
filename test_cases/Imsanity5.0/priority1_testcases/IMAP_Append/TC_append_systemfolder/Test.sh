#!/bin/bash
imap_append "$Sanityuser" "INBOX" "{2}" "Hi"
summary "IMAP:TC_append_systemfolder" $Result
