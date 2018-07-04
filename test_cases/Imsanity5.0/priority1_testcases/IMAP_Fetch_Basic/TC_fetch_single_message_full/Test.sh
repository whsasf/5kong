#!/bin/bash

	
imap_fetch "$Sanityuser" "1" "full"   
summary "IMAP:TC_fetch_single_message_full" $Result