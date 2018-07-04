#!/bin/bash

imap_fetch "$Sanityuser" "1:2,3" "envelope"
summary "IMAP:TC_fetch_option2_message_envelope" $Result