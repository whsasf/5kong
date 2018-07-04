#!/bin/bash
  
imap_fetch "$Sanityuser" "1,2,3" "flags"
summary "IMAP:TC_fetch_multiple_message_flags" $Result