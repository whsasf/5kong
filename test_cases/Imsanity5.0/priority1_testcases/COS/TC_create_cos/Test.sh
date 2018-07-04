#!/bin/bash
> debug.log
> summary.log
start_time_tc

#create cos bogus
create_cos bogus
summary "COS:TC_create_cos" $Result