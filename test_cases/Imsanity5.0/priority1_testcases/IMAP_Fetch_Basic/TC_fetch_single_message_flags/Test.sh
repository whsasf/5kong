#!/bin/bash

imap_fetch "$Sanityuser" "1" "flags"
summary "IMAP:TC_fetch_single_message_flags" $Result