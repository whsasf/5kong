#!/bin/bash
unshareFolder "$mxoshost_port" "$Sanityuser1" "$Sanityuser2"  "New_folder"
  
summary "Sharefolder:TC_UnshareFolder_custom" $Result
	
