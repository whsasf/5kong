#!/bin/bash
unshareFolder "$mxoshost_port" "$Sanityuser1" "$Sanityuser2"  "Trash"
  
summary "Sharefolder:TC_UnshareFolder_system" $Result
	
