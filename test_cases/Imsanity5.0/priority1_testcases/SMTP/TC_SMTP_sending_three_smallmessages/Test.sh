#!/bin/bash

#sending 3 small messages
mail_send "$Sanityuser" "small" "3"
summary "SMTP:TC_SMTP_sending_three_smallmessages" $Result