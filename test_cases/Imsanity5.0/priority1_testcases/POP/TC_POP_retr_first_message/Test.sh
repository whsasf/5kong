#!/bin/bash

mail_send "$Sanityuser" "small" "3"
pop_retrieve "$Sanityuser" "1"      
summary "POP:TC_POP_retr_first_message" $Result

