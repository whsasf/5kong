#!/bin/bash

mail_send "$Sanityuser" "small" "2"
pop_delete "$Sanityuser"
summary "POP:TC_POP_Delete" $Result 

