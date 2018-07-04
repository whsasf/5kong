#!/bin/bash
mail_send $Sanityuser "small" "2"
imap_examine $Sanityuser "INBOX"
summary "IMAP:TC_Imap_Examine" $Result