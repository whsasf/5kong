#!/bin/bash


imap_fetch "$Sanityuser" "1:3" "body[text]"      
summary "IMAP:TC_fetch_range_message_body_text" $Result