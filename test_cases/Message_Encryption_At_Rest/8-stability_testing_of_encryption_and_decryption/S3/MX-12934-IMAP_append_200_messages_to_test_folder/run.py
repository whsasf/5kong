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
total_bldy_flag = 0
basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx1_imapserv_host1_imap4Port,mx1_imapserv_host1_ip,AES_mode1,mx1_mxos_host1_eureka_port,mx1_search_cassandraBlobPort,mx1_cassblob_ip,mx1_mxos_host1_ip,ASE_key128,AES_mode1,mx1_mta_host1_SMTPPort,mx1_mta_host1_ip,mx1_mxos_host1_eureka_port,mx1_mxos_host1_ip,mx1_mss_host2_ip,mx1_mss_host1_ip,mx1_popserv_host1,mx1_popserv_host1_pop3Port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,mx1_default_domain = \
global_variables.get_values('mx1_imapserv_host1_imap4Port','mx1_imapserv_host1_ip','AES_mode1','mx1_mxos_host1_eureka_port','mx1_search_cassandraBlobPort','mx1_cassblob_ip','mx1_mxos_host1_ip','ASE_key128','AES_mode1','mx1_mta_host1_SMTPPort','mx1_mta_host1_ip','mx1_mxos_host1_eureka_port','mx1_mxos_host1_ip','mx1_mss_host2_ip','mx1_mss_host1_ip','mx1_popserv_host1','mx1_popserv_host1_pop3Port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','mx1_default_domain')

#basic_class.mylogger_record.debug('step1:fetching the latest message uuid')
#uuid = mxos_operations_MessageBodyEncryption.fetch_latest_message_uuid(mx1_mxos_host1_ip,mx1_mxos_host1_eureka_port,'testuser1@openwave.com')
#
#basic_class.mylogger_record.debug('step2:fetch message body from cassandrablob directly')
#
#encrypted_flag,messagebody1 = cassandra_operations.cassandra_cqlsh_fetch_messagebody(mx1_cassblob_ip,mx1_search_cassandraBlobPort,uuid,AES_mode1)
#
#body_check_flag1 = messagebody1.count('This world could be better')
#basic_class.mylogger_record.debug('body_check_flag1= '+str(body_check_flag1))
#
#if encrypted_flag == 1 and body_check_flag1 >=1:
#    result_lists.append('fetch messagebody from cassandra success')
#else:
#    result_lists.append('fetch messagebody from cassandra fail')    


basic_class.mylogger_record.info('step3:fetch message body from IMAP')
myimap = imap_operations.IMAP_Ops(mx1_imapserv_host1_ip,mx1_imapserv_host1_imap4Port)
myimap.imap_login('testuser1','testuser1')
myimap.imap_select('customerfolder')                          
for i in range(1,201):
    messagebody2 = myimap.imap_fetch('{}'.format(i),'rfc822.header')
    messagebody2 = myimap.imap_fetch('{}'.format(i),'rfc822')
    body_check_flag2 = messagebody2[1].count('This world could be better')
    basic_class.mylogger_record.debug('body_check_flag2 = '+str(body_check_flag2))
    total_bldy_flag += body_check_flag2 
myimap.imap_logout()



basic_class.mylogger_record.debug('total_bldy_flag= '+str(total_bldy_flag))    
if total_bldy_flag == 200:
    result_lists.append('fetch messagebody from IMAP success')
else:
    result_lists.append('fetch messagebody from IMAP fail')
    
basic_function.summary(result_lists)