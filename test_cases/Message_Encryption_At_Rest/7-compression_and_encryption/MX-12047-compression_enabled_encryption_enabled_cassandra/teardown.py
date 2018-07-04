#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

##steps:
# (1) restore keys:
#               /*/common/messageBodyEncryptionEnabled:[false]
#               /*/mss/compressionEnabled: [true]   # need mss restart
# (2) create 6 accounts:testuser1@openwave.com -test6@openwave.com
# (3) clear current popserv.stat file
import basic_function
import basic_class
import imap_operations
import smtp_operations
import global_variables
import remote_operations
import mxos_operations_MessageBodyEncryption
import time

basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx1_mxos2_host_ip,mx1_mta1_port,mx1_mta1_host_ip,mx1_mxos1_port,mx1_mxos1_host_ip,mx1_mss2_host_ip,mx1_mss1_host_ip,mx1_pop1_host,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx1_mxos2_host_ip','mx1_mta1_port','mx1_mta1_host_ip','mx1_mxos1_port','mx1_mxos1_host_ip','mx1_mss2_host_ip','mx1_mss1_host_ip','mx1_pop1_host','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')


basic_class.mylogger_record.info('step1:delete 2 accounts')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=2;i++));do account-delete {1}$i@{2};done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Deleted Successfully',2)


basic_class.mylogger_record.info('step2:restore keys and restart services')   
#imconfcontrol -install -key \"/*/mxos/loadRulesOrder=domain\nmailbox\ncos\nmessage\ncustom\nadminrealm\nlogging\naddressbook\nnotify\nsaml\ntasks\ndatastore\nmailinglist\n\";
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/mss/compressionEnabled=true\";imconfcontrol -install -key \"/*/mxos/ldapEncryptionDn\";imconfcontrol -install -key \"/*/mxos/ldapReadEncryptionFilter\";imconfcontrol -install -key \"/*/common/messageBodyEncryptionEnabled=false\"\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mss1_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mss\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mss2_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mss mxos\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mxos1_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mxos\''.format(mx_account),0)


