#!/bin/bash

mail_send "$Sanityuser" "small" "3"
pop_retrieve "$Sanityuser" "2"      
summary "POP:TC_POP_retr_second_message" $Result

