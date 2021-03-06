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
import mxos_operations_MessageBodyEncryption
import time


basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx1_imapserv_host1_imap4Port,mx1_imapserv_host1_ip,mx1_mxos_host2_ip,ASE_key128,AES_mode1,mx1_mta_host1_SMTPPort,mx1_mta_host1_ip,mx1_mxos_host1_eureka_port,mx1_mxos_host1_ip,mx1_mss_host2_ip,mx1_mss_host1_ip,mx1_popserv_host1,mx1_popserv_host1_pop3Port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,mx1_default_domain = \
global_variables.get_values('mx1_imapserv_host1_imap4Port','mx1_imapserv_host1_ip','mx1_mxos_host2_ip','ASE_key128','AES_mode1','mx1_mta_host1_SMTPPort','mx1_mta_host1_ip','mx1_mxos_host1_eureka_port','mx1_mxos_host1_ip','mx1_mss_host2_ip','mx1_mss_host1_ip','mx1_popserv_host1','mx1_popserv_host1_pop3Port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','mx1_default_domain')

basic_class.mylogger_record.info('step1:set keys and restart services')
remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'imconfcontrol -install -key \"/*/common/blobStoreAmazonS3Key=blobtier otosankey\";imconfcontrol -install -key \"/*/common/blobStoreAmazonS3KeyId=blobtier otosan\";imconfcontrol -install -key \"/*/common/hostInfo=blobtier=S3:scality.otosan.opwv:80\";imconfcontrol -install -key \"/*/common/blobStoreAmazonS3Key=blobtier otosankey\";imconfcontrol -install -key \"/*/common/blobStoreAmazonS3KeyId=blobtier otosan\";imconfcontrol -install -key \"/*/common/hostInfo=blobtier=S3:scality.otosan.opwv:80\";imconfcontrol -install -key \"/*/common/messageBodyEncryptionEnabled=false\";imconfcontrol -install -key \"/*/mss/compressionEnabled=true\"\''.format(mx_account),root_account,root_passwd,0)
remote_operations.remote_operation(mx1_mss_host1_ip,'su - {0} -c \'~/lib/imservctrl killStart mss\''.format(mx_account),root_account,root_passwd,0)
remote_operations.remote_operation(mx1_mss_host2_ip,'su - {0} -c \'~/lib/imservctrl killStart mss mxos\''.format(mx_account),root_account,root_passwd,0)
remote_operations.remote_operation(mx1_mxos_host2_ip,'su - {0} -c \'~/lib/imservctrl killStart mxos\''.format(mx_account),root_account,root_passwd,0)

basic_class.mylogger_record.info('Sleeping 200 seconds ...')
time.sleep(200)

#basic_class.mylogger_record.info('set passphrase')
#cuid,cpassphrase = mxos_operations_MessageBodyEncryption.fetch_current_uid_passphrase(mx1_mxos_host1_ip,mx1_mxos_host1_eureka_port)
#basic_class.mylogger_record.info('cuid,cpassphrase: '+str(cuid)+','+cpassphrase)

#if int(cuid) == -1:
#    exit (1)
#else:
#    pass
#basic_class.mylogger_record.info('new passphrase uid is: '+str(cuid))        
#mxos_operations_MessageBodyEncryption.create_passphrase(mx1_mxos_host1_ip,mx1_mxos_host1_eureka_port,str(cuid),AES_mode1,ASE_key128)

# restart mss to froce to use new encryption key
#remote_operations.remote_operation(mx1_mss_host1_ip,'su - {0} -c \'~/lib/imservctrl killStart mss\''.format(mx_account),root_account,root_passwd,0)
#time.sleep(60)

basic_class.mylogger_record.info('step2:create 2 accounts')
remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'for ((i=1;i<=2;i++));do account-create {1}$i@{2}   {1}$i default;done\''.format(mx_account,test_account_base,mx1_default_domain),root_account,root_passwd,1,'Mailbox Created Successfully',2)
remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'for ((i=1;i<=2;i++));do immsgdelete {1}$i@{2}   -all;done\''.format(mx_account,test_account_base,mx1_default_domain),root_account,root_passwd,0)

basic_class.mylogger_record.info('step3:MTA send 1 message to testuser1 to INBOX')
smtp_operations.fast_send_mail(mx1_mta_host1_ip,mx1_mta_host1_SMTPPort,'testuser2',[test_account_base+'1'])
time.sleep(3)
#myimap = imap_operations.IMAP_Ops(mx1_imapserv_host1_ip,mx1_imapserv_host1_imap4Port)
#myimap.imap_login('testuser1','testuser1')
#myimap.imap_select()
#myimap.imap_append()
#myimap.imap_logout()

