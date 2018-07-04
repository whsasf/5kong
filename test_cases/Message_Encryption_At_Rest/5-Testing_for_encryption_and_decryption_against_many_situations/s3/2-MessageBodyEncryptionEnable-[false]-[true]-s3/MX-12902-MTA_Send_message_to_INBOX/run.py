#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import basic_function
import basic_class
import imap_operations
import smtp_operations
import global_variables
import remote_operations
import mxos_operations_MessageBodyEncryption
import time
import requests
import cassandra_operations

result_lists = []

basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx1_imap1_port,mx1_imap1_host_ip,AES_mode1,mx1_mxos1_port,mx1_blobstore_port,mx1_blobstore_host_ip,mx1_mxos2_host_ip,ASE_key128,AES_mode1,mx1_mta1_port,mx1_mta1_host_ip,mx1_mxos1_port,mx1_mxos1_host_ip,mx1_mss2_host_ip,mx1_mss1_host_ip,mx1_pop1_host,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx1_imap1_port','mx1_imap1_host_ip','AES_mode1','mx1_mxos1_port','mx1_blobstore_port','mx1_blobstore_host_ip','mx1_mxos2_host_ip','ASE_key128','AES_mode1','mx1_mta1_port','mx1_mta1_host_ip','mx1_mxos1_port','mx1_mxos1_host_ip','mx1_mss2_host_ip','mx1_mss1_host_ip','mx1_pop1_host','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')

#basic_class.mylogger_record.info('step1:fetching the latest message uuid')
#uuid1 = mxos_operations_MessageBodyEncryption.fetch_latest_message_uuid(mx1_mxos1_host_ip,mx1_mxos1_port,'testuser1@openwave.com')
#
#basic_class.mylogger_record.info('step2:fetch message body from cassandrablob directly')
#
#encrypted_flag,messagebody1 = cassandra_operations.cassandra_cqlsh_fetch_messagebody(mx1_blobstore_host_ip,mx1_blobstore_port,uuid1,0)
#
#body_check_flag1 = messagebody1.count('attachement,haha,are you OK? we love world')
#basic_class.mylogger_record.debug('body_check_flag1= '+str(body_check_flag1))
#
#if encrypted_flag == 0 and body_check_flag1 >=1:
#    result_lists.append('fetch messagebody from cassandra success')
#else:
#    result_lists.append('fetch messagebody from cassandra fail')    


basic_class.mylogger_record.info('step3:fetch message body from IMAP')
myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
myimap.imap_login('testuser1','testuser1')
myimap.imap_select()
messagebody2 = myimap.imap_fetch('1','rfc822')
myimap.imap_logout()

body_check_flag2 = messagebody2[1].count('attachement,haha,are you OK? we love world')
basic_class.mylogger_record.debug('body_check_flag2 = '+str(body_check_flag2))

    
if body_check_flag2 >=1:
    result_lists.append('fetch messagebody from IMAP success')
else:
    result_lists.append('fetch messagebody from IMAP fail')


basic_class.mylogger_record.debug('step4:enable encryption')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/messageBodyEncryptionEnabled=true\";imconfcontrol -install -key \"/*/mss/compressionEnabled=false\";imconfcontrol -install -key \"/*/mxos/ldapEncryptionDn=cn=encryption,cn=config\";imconfcontrol -install -key \"/*/mxos/ldapReadEncryptionFilter=(&(objectclass=messageBodyEncryption)(cn=encryption))\"\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mss1_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mss\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mss2_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mss mxos\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mxos2_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mxos\''.format(mx_account),0)

basic_class.mylogger_record.info('Sleeping 220 seconds ...')
time.sleep(220)



basic_class.mylogger_record.info('set passphrase')
cuid,cpassphrase = mxos_operations_MessageBodyEncryption.fetch_current_uid_passphrase(mx1_mxos1_host_ip,mx1_mxos1_port)
basic_class.mylogger_record.info('cuid,cpassphrase: '+str(cuid)+','+cpassphrase)

if int(cuid) == -1:
    exit (1)
else:
    pass
basic_class.mylogger_record.info('new passphrase uid is: '+str(cuid))        
mxos_operations_MessageBodyEncryption.create_passphrase(mx1_mxos1_host_ip,mx1_mxos1_port,str(cuid),AES_mode1,ASE_key128)

# restart mss to froce to use new encryption key
remote_operations.remote_operation(mx1_mss1_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mss\''.format(mx_account),0)
remote_operations.remote_operation(mx1_mss2_host_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mss\''.format(mx_account),0)

time.sleep(30)


basic_class.mylogger_record.info('step5:MTA send  another messege to inbox again')
#myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
#myimap.imap_login('testuser1','testuser1')
#myimap.imap_select()
#myimap.imap_append()
#myimap.imap_logout()

smtp_operations.fast_send_mail(mx1_mta1_host_ip,mx1_mta1_port,'testuser2',[test_account_base+'1'])
time.sleep(8)

#basic_class.mylogger_record.debug('step6:fetching the latest message uuid')
#uuid2 = mxos_operations_MessageBodyEncryption.fetch_latest_message_uuid(mx1_mxos1_host_ip,mx1_mxos1_port,'testuser1@openwave.com')
#
#basic_class.mylogger_record.debug('step7:fetch message body from cassandrablob directly')
#
#encrypted_flag,messagebody1 = cassandra_operations.cassandra_cqlsh_fetch_messagebody(mx1_blobstore_host_ip,mx1_blobstore_port,uuid2,AES_mode1)
#
#body_check_flag1 = messagebody1.count('attachement,haha,are you OK? we love world')
#basic_class.mylogger_record.debug('body_check_flag1= '+str(body_check_flag1))
#
#if encrypted_flag == 1 and body_check_flag1 >=1:
#    result_lists.append('fetch messagebody from cassandra success')
#else:
#    result_lists.append('fetch messagebody from cassandra fail')    
#

basic_class.mylogger_record.info('step8:fetch message body from IMAP')
myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
myimap.imap_login('testuser1','testuser1')
myimap.imap_select()
messagebody2 = myimap.imap_fetch('2','rfc822')
myimap.imap_logout()

body_check_flag2 = messagebody2[1].count('attachement,haha,are you OK? we love world')
basic_class.mylogger_record.debug('body_check_flag2 = '+str(body_check_flag2))

    
if body_check_flag2 >=1:
    result_lists.append('fetch messagebody from IMAP success')
else:
    result_lists.append('fetch messagebody from IMAP fail')



#basic_class.mylogger_record.debug('step9:fetch first message body from cassandrablob directly')
#
#encrypted_flag,messagebody1 = cassandra_operations.cassandra_cqlsh_fetch_messagebody(mx1_blobstore_host_ip,mx1_blobstore_port,uuid1,0)
#
#body_check_flag1 = messagebody1.count('attachement,haha,are you OK? we love world')
#basic_class.mylogger_record.debug('body_check_flag1= '+str(body_check_flag1))
#
#if encrypted_flag == 0 and body_check_flag1 >=1:
#    result_lists.append('fetch messagebody from cassandra success')
#else:
#    result_lists.append('fetch messagebody from cassandra fail')    
    
    
basic_class.mylogger_record.info('step10:fetch first message body from IMAP')
myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
myimap.imap_login('testuser1','testuser1')
myimap.imap_select()
messagebody2 = myimap.imap_fetch('1','rfc822')
myimap.imap_logout()

body_check_flag2 = messagebody2[1].count('attachement,haha,are you OK? we love world')
basic_class.mylogger_record.debug('body_check_flag2 = '+str(body_check_flag2))

    
if body_check_flag2 >=1:
    result_lists.append('fetch messagebody from IMAP success')
else:
    result_lists.append('fetch messagebody from IMAP fail')


basic_function.summary(result_lists)