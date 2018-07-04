#!/bin/bash
ldap_modify_utility $Sanityuser replace mailpassword abcd
summary "LDAPMODIFY" $Result