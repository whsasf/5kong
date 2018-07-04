#!/bin/bash

imap_fetch "$Sanityuser" "1:*" "envelope"
summary "IMAP:TC_fetch_all_message_envelope" $Result