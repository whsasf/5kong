#!/bin/bash
imap_store "$Sanityuser" "1" "-" "bb" "INBOX"
summary "IMAP:TC_store_removekeywords" $Result