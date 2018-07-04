#!/bin/bash


imap_fetch "$Sanityuser" "1,2,3" "full" 
summary "IMAP:TC_fetch_multiple_message_full" $Result