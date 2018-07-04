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

basic_class.mylogger_record.debug('step1:fetching the latest message uuid')
uuid = mxos_operations_MessageBodyEncryption.fetch_latest_message_uuid(mx1_mxos1_host_ip,mx1_mxos1_port,'testuser1@openwave.com','customerfolder')

basic_class.mylogger_record.debug('step2:fetch message body from cassandrablob directly')

encrypted_flag,messagebody1 = cassandra_operations.cassandra_cqlsh_fetch_messagebody(mx1_blobstore_host_ip,mx1_blobstore_port,uuid,0)

body_check_flag1 = messagebody1.count(' we love world !!!!!!ucucucucucuc')
basic_class.mylogger_record.debug('body_check_flag1= '+str(body_check_flag1))

if encrypted_flag == 0 and body_check_flag1 >=1:
    result_lists.append('fetch messagebody from cassandra success')
else:
    result_lists.append('fetch messagebody from cassandra fail')    


basic_class.mylogger_record.info('step3:fetch message body from IMAP')
myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
myimap.imap_login('testuser1','testuser1')
myimap.imap_select('customerfolder')
messagebody2 = myimap.imap_fetch('1','rfc822')
myimap.imap_logout()

body_check_flag2 = messagebody2[1].count(' we love world !!!!!!ucucucucucuc')
basic_class.mylogger_record.debug('body_check_flag2 = '+str(body_check_flag2))

    
if body_check_flag2 >=1:
    result_lists.append('fetch messagebody from IMAP success')
else:
    result_lists.append('fetch messagebody from IMAP fail')
    
basic_function.summary(result_lists)