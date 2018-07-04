#!/bin/bash

mail_send "$Sanityuser" "small" "3"
pop_retrieve "$Sanityuser" "3"      
summary "POP:TC_POP_retr_third_message" $Result

