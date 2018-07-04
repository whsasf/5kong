#!/bin/bash


#sending 1 large messages
mail_send "$Sanityuser" "large" "1"
summary "SMTP:TC_SMTP_sending_one_largemessages" $Result