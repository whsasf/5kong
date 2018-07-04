#!/bin/bash

#delete forward
delete_remote_fwd $Sanityuser1 $Sanityuser2
#delete test acocunt

account_delete_fn $Sanityuser1
account_delete_fn $Sanityuser2
