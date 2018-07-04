#!/bin/bash
imap_store "$Sanityuser" "1" "+" "aa" "INBOX"
summary "IMAP:TC_store_addkeywords" $Result
