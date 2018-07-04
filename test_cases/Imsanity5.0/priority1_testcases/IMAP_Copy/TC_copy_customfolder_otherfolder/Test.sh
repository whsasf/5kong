#!/bin/bash
imap_copy "$Sanityuser" "3" "folder2" "folder1"
		
summary "IMAP:TC_copy_customfolder_otherfolder" $Result
