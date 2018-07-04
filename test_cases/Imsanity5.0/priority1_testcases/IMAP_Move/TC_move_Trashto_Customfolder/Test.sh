#!/bin/bash
imap_move "$Sanityuser" "1" "folder1" "Trash"
			
summary "IMAP:TC_move_Trashto_Customfolder" $Result
