#!/bin/bash

#sending 5 small messages
mail_send "$Sanityuser" "small" "5"
summary "SMTP:TC_SMTP_sending_five_smallmessages" $Result