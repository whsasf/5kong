#!/bin/bash


imap_fetch "$Sanityuser" "1:3" "full"    
summary "IMAP:TC_fetch_range_message_full" $Result