#!/bin/bash
imap_fetch $Sanityuser "1:3"      
summary "IMAP:TC_fetch_range_message_rfc822" $Result