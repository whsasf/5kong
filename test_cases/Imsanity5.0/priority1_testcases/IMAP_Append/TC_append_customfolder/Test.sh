#!/bin/bash
imap_append "$Sanityuser" "folder12" "{3}" "Hey"
summary "IMAP:TC_append_customfolder" $Result
