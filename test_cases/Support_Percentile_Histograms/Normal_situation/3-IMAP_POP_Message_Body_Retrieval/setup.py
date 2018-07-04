#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# test steps:

#1 set keys as below:
#
#/*/common/perfStatThresholds:[StatMSSRetrMsg 200]
#/*/common/reportParamsInterval: [30]
#/*/common/hostInfo: [blobtier=Cassandra:blobcluster:9162]
#/*/mta/subAddressAllowedIPs:[127.0.0.1][10.49.58.239][10.37.2.214]
#/site1-inbound-standardmta-direct/mta/subAddressAllowedIPs:[127.0.0.1][10.49.58.239][10.37.2.214]
# /*/imapserv/enableMOVE: [true]
#
#
#2 create 6 account:
#testuser1@openwave.com - testuser6@openwave.com
#
#3 for each account, do below operations: 
#(1) imap create test folder
#(2) imap append 2 messages into INBOX ,now INBOX:3 ,test:0
#(3) imap append 2 messages into test,now   INBOX:3 ,test:2
#(4) smtp send 2 messages to INBOX, now     INBOX:5 ,test:2
#(5) smtp send 2 mssagees to test,now       INBOX:5 ,test:4
#(6) select test
#(7) copy 3:4 from test to INBOX,now        INBOX:7 ,test:4
#(8) select inbox
#(9) move 1:2 from INBOX to test,now        INBOX:5 ,test:6
#(10) switch blobstore from cassandra to scality s3 
#/*/common/hostInfo: [blobtier=S3:scality.otosan.opwv:80] 
#/*/common/blobStoreAmazonS3Key: [blobtier otosankey] 
#/*/common/blobStoreAmazonS3KeyId: [blobtier otosan] 
#(11) imap append 2 mssagees to test,now      INBOX:5 ,test:8
#(12) imap append 2 mssagees to test,now      INBOX:7 ,test:8
#(13) switch blobstore from scality s3 to cassandra
#/*/common/hostInfo: [blobtier=Cassandra:blobcluster:9162]
#(14) now INBOX:7 (last 2 message should not fetched successfully),
#         test:8 (last 2 message should not fetched successfully)


import basic_function   
import basic_class      
import imap_operations  
from sendmails import send_mail
import global_variables 
import remote_operations
import time
import os
import sys
             
#currentpath = os.getcwd()
#sys.path.append(currentpath)

basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')                                                               
                                                                                                                                                    
mx1_mss1_host_ip,mx1_mss2_host_ip,mx1_imap1_host_ip,mx1_imap1_port,mx1_mta1_host_ip,mx1_mta1_port,mx1_pop1_host_ip,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx1_mss1_host_ip','mx1_mss2_host_ip','mx1_imap1_host_ip','mx1_imap1_port','mx1_mta1_host_ip','mx1_mta1_port','mx1_pop1_host_ip','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')

basic_class.mylogger_record.info('step1:set keys')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/imapserv/enableMOVE=true\";imconfcontrol -install -key \"/*/common/reportParamsInterval=30\";imconfcontrol -install -key \"/*/common/hostInfo=blobtier=Cassandra:blobcluster:9162\";imconfcontrol -install -key \"/*/mta/subAddressAllowedIPs=127.0.0.1\n10.49.58.239\n10.37.2.214\n10.6.105.42\";imconfcontrol -install -key \"/site1-inbound-standardmta-direct/mta/subAddressAllowedIPs=127.0.0.1\n10.49.58.239\n10.37.2.214\n10.6.105.42\"\''.format(mx_account),0)
basic_class.mylogger_record.info(' restart mss') 
remote_operations.remote_operation(mx1_mss1_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart mss mta"'.format(mx_account),0)
remote_operations.remote_operation(mx1_mss2_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart mss"'.format(mx_account),0)
time.sleep(10)  
  
basic_class.mylogger_record.info('step2:create 6 accounts')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=6;i++));do account-create {1}$i@{2}   {1}$i default;done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Created Successfully',6)

basic_class.mylogger_record.info('step3:for each account, do below operations')
outcome = []
for i in range(1,6):
    basic_class.mylogger_recordnf.title('doing operations against'+test_account_base+str(i))
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))

    basic_class.mylogger_record.info('step3-1:imap create test folder')
    myimap.imap_create('test')

    basic_class.mylogger_record.info('step3-2:imap append 2 messages into INBOX ,now INBOX:3 ,test:0')
    myimap.imap_select()
    myimap.imap_append(message=b"From:tom\nTo:lucy\nSubject:haha\n\nffffffffffffffffffff",mailbox='INBOX')
    time.sleep(2)
    myimap.imap_append()
    time.sleep(5)
    myimap.imap_select()
    
    basic_class.mylogger_record.info('step3-3:imap append 2 messages into test,now INBOX:3 ,test:2')
    myimap.imap_select('test')
    myimap.imap_append(message=b"From:big hail\nTo:tree\nSubject:haha\n\nwe are good friends,\nare you OK?",mailbox='test')
    time.sleep(2)
    myimap.imap_append(message=b"From:small tose\nTo:flower\nSubject:haha\n\ngo away,people will hert you badly\nremember this~",mailbox='test')
    time.sleep(5)
    myimap.imap_select('test')
    
    basic_class.mylogger_record.info('step3-4:smtp send 2 messages to INBOX, now  INBOX:5 ,test:2')
    sender = 'testuser6 <testuser6@openwave.com>'
    
    basic_class.mylogger_record.info('step3-4-1:clear mta.log')
    remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "> log/mta.log"'.format(mx_account),0)
    basic_class.mylogger_record.info('step3-4-2:deliver message')
    send_mail(mx1_mta1_host_ip,mx1_mta1_port,sender,[test_account_base+str(i)])
    send_result = remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/mta.log"'.format(mx_account),1,'delivered',1)
    time.sleep(5)
    myimap.imap_select()
    
    basic_class.mylogger_record.info('step3-4-3:clear mta.log')
    remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "> log/mta.log"'.format(mx_account),0)
    basic_class.mylogger_record.info('step3-4-4:deliver message')
    send_mail(mx1_mta1_host_ip,mx1_mta1_port,sender,[test_account_base+str(i)])
    send_result = remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/mta.log"'.format(mx_account),1,'delivered',1)
    myimap.imap_select()
    time.sleep(2)
    
    basic_class.mylogger_record.info('step3-5:smtp send 2 mssagees to test,now INBOX:5 ,test:4')
    basic_class.mylogger_record.info('step3-5-1:clear mta.log')
    remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "> log/mta.log"'.format(mx_account),0)
    basic_class.mylogger_record.info('step3-5-2:deliver message')
    send_mail(mx1_mta1_host_ip,mx1_mta1_port,sender,[test_account_base+str(i)+'+test'])
    send_result = remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/mta.log"'.format(mx_account),1,'delivered to test folder',1)
    
    time.sleep(5)
    myimap.imap_select('test')
    
    basic_class.mylogger_record.info('step3-5-3:clear mta.log')
    remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "> log/mta.log"'.format(mx_account),0)
    basic_class.mylogger_record.info('step3-5-4:deliver message')
    send_mail(mx1_mta1_host_ip,mx1_mta1_port,sender,[test_account_base+str(i)+'+test'])
    send_result = remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/mta.log"'.format(mx_account),1,'delivered to test folder',1)
    time.sleep(5)
    myimap.imap_select('test')
    myimap.imap_logout()
    
    
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    basic_class.mylogger_record.info('step3-6: select test')
    myimap.imap_select('test')
    
    basic_class.mylogger_record.info('step3-7: copy 3:4 from test to INBOX,now INBOX:7 ,test:4') 
    myimap.imap_copy('3,4','INBOX')
    myimap.imap_select()
    time.sleep(5)
    
    basic_class.mylogger_record.info('step3-8: select inbox') 
    myimap.imap_select()
    
    basic_class.mylogger_record.info('step3-9: move 1:2 from INBOX to test,now INBOX:5 ,test:6') 
    myimap.imap_move('1:2','test')
    myimap.imap_select()
    myimap.imap_select('test')
    myimap.imap_logout()
    
    time.sleep(5)
    
    basic_class.mylogger_record.info('step3-10-1: switch blobstore from cassandra to scality s3 ') 
    remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/hostInfo=blobtier=S3:scality.otosan.opwv:80\";imconfcontrol -install -key \"/*/common/blobStoreAmazonS3Key=blobtier otosankey\";imconfcontrol -install -key \"/*/common/blobStoreAmazonS3KeyId=blobtier otosan\"\''.format(mx_account),0)
    time.sleep(2)
    basic_class.mylogger_record.info(' restart mss') 
    remote_operations.remote_operation(mx1_mss1_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart mss"'.format(mx_account),0)
    remote_operations.remote_operation(mx1_mss2_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart mss"'.format(mx_account),0)
   
    time.sleep(10)
    
    basic_class.mylogger_record.info('step3-11: imap append 2 mssagees to test,now  INBOX:5 ,test:8') 
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_append(message=b"From:big hail\nTo:tree\nSubject:haha\n\nwe are good friends,\nare you OK?",mailbox='test')
    time.sleep(2)
    myimap.imap_append(message=b"From:small tose\nTo:flower\nSubject:haha\n\ngo away,people will hert you badly\nremember this~",mailbox='test')
    time.sleep(2)

    target1 = myimap.imap_select('test')
    if int(target1) == 8:
        basic_class.mylogger_recordnf.yes('correct messages number for test folder')
        outcome.append(target1)
    else:
        basic_class.mylogger_recordnf.no('wrong messages number for test folder')
        outcome.append(target1)
        exit (1)
        
    basic_class.mylogger_record.info('step3-12: imap append 2 mssagees to INBOX,now  INBOX:7 ,test:8')  
    myimap.imap_append(message=b"From:big hail\nTo:tree\nSubject:haha\n\nwe are good friends,\nare you OK?",mailbox='INBOX')
    time.sleep(2)
    myimap.imap_append(message=b"From:small tose\nTo:flower\nSubject:haha\n\ngo away,people will hert you badly\nremember this~",mailbox='INBOX')
    time.sleep(2)
    target2 = myimap.imap_select() 
    myimap.imap_logout()

    if int(target2) == 7:
        basic_class.mylogger_recordnf.yes('correct messages number for INBOX folder')
        outcome.append(target2)
    else:
        basic_class.mylogger_recordnf.no('wrong messages number for INBOX folder')
        outcome.append(target2)
        exit (1)   
               
    basic_class.mylogger_record.info('step3-13: switch blobstore from scality s3 to cassandra')  
    remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/hostInfo=blobtier=Cassandra:blobcluster:9162\"\''.format(mx_account),0)
    basic_class.mylogger_record.info(' restart mss') 
    remote_operations.remote_operation(mx1_mss1_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart mss"'.format(mx_account),0)
    remote_operations.remote_operation(mx1_mss2_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart mss"'.format(mx_account),0)
    time.sleep(10)
    
print(outcome)    

    
    
    
    
    
   
    
