#!/bin/bash

mail_send "$Sanityuser" "small" "4"
pop_uidl $Sanityuser  4
summary "POP:TC_POP_uidl" $Result

