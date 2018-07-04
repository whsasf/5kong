#!/bin/bash

imap_fetch "$Sanityuser" "1:3" "envelope"
summary "IMAP:TC_fetch_range_message_envelope" $Result