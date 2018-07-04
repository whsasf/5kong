#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

##steps:
# (1) set keys:
#               /*/common/messageBodyEncryptionEnabled:[false]
#               /*/mss/compressionEnabled: [false]   # need mss retart
#               /*/mxos/ldapEncryptionDn: [cn=encryption,cn=config]
#               /*/mxos/ldapReadEncryptionFilter: [(&(objectclass=messageBodyEncryption)(cn=encryption))]
#               /*/mxos/loadRulesOrder:[encryption]
# (2) create 6 accounts:testuser1@openwave.com -test2@openwave.com
# (3) clear current popserv.stat file

import basic_function
import basic_class
import imap_operations
import smtp_operations
import global_variables
import remote_operations
import time

basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx1_mta1_port,mx1_mta1_host_ip,mx1_mxos2_port,mx1_mxos2_host_ip,mx1_mss2_host_ip,mx1_mss1_host_ip,mx1_pop1_host,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx1_mta1_port','mx1_mta1_host_ip','mx1_mxos2_port','mx1_mxos2_host_ip','mx1_mss2_host_ip','mx1_mss1_host_ip','mx1_pop1_host','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')

basic_class.mylogger_record.info('step1:set keys and restart services')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/blobStoreAmazonS3Key=blobtier otosankey\";imconfcontrol -install -key \"/*/common/blobStoreAmazonS3KeyId=blobtier otosan\";imconfcontrol -install -key \"/*/common/hostInfo=blobtier=S3:scality.otosan.opwv:80\";imconfcontrol -install -key \"/*/common/messageBodyEncryptionEnabled=false\";imconfcontrol -install -key \"/*/mss/compressionEnabled=true\"\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mss1_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mss\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mss2_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mss mxos\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mxos2_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mxos\''.format(mx_account),0)

basic_class.mylogger_record.info('sleeping 200 seconds')
time.sleep(200)

basic_class.mylogger_record.info('step2:create 2 accounts')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=2;i++));do account-create {1}$i@{2}   {1}$i default;done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Created Successfully',2)
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=2;i++));do immsgdelete {1}$i@{2}   -all;done\''.format(mx_account,test_account_base,default_domain),0)

basic_class.mylogger_record.info('step3:deliever 1 message from testuser2 to testuser1')
	
smtp_operations.fast_send_mail(mx1_mta1_host_ip,mx1_mta1_port,'testuser2',[test_account_base+'1'])

