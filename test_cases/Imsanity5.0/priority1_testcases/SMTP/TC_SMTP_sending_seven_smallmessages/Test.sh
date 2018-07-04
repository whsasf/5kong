#!/bin/bash

#sending 7 small messages
mail_send "$Sanityuser" "small" "7"
summary "SMTP:TC_SMTP_sending_seven_smallmessages" $Result