#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##steps:
# (1) imap login 5 accounts with correct credentials, the other 5 use wrong credentials
# (2) check and analyze imapserv.stat file .make sure the total attempts are 20 ,and half passed ,half failed

import basic_function
import basic_class
import imap_operations
import global_variables
import time
import remote_operations
import stat_statistics

#step 1
basic_class.mylogger_record.info('step1:imap login:5 account with correct passwd, the other 5 use wrong pssswd')


mx2_imap1_host_ip,mx2_mss1_host_ip,mx2_mta1_port,mx2_mta1_host_ip,mx2_host1_ip,mx2_pop1_port,mx2_pop1_host,mx2_imap1_port,mx2_imap1_host,mx1_mss1_host_ip,mx1_mss2_host_ip,mx1_imap1_host_ip,mx1_imap1_port,mx1_mta1_host_ip,mx1_mta1_port,mx1_pop1_host_ip,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx2_imap1_host_ip','mx2_mss1_host_ip','mx2_mta1_port','mx2_mta1_host_ip','mx2_host1_ip','mx2_pop1_port','mx2_pop1_host','mx2_imap1_port','mx2_imap1_host','mx1_mss1_host_ip','mx1_mss2_host_ip','mx1_imap1_host_ip','mx1_imap1_port','mx1_mta1_host_ip','mx1_mta1_port','mx1_pop1_host_ip','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')


for i in range(1,6): 
    mximap1 = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    try:
        mximap1.imap_login('u'+str(i)+'@'+default_domain,test_account_base+str(i)) # using correct passwd
        basic_class.mylogger_record.info('imap alias login success')
    except:
        basic_class.mylogger_record.error('imap alias login fail')
    mximap1.imap_select()
    mximap1.imap_logout()

for i in range(6,11): 
    mximap2 = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    try:
        mximap2.imap_login('u'+str(i)+'@'+default_domain,'password') # using wrong passwd :password here
    except:
        basic_class.mylogger_record.error('imap alias login fail')
    mximap2.imap_logout()
    
#step 2
basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('step2:check and analyze imapserv.stat file ...')
imapserv_stat_content1 = remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatImapAuthCommand"'.format(mx_account),0)
imapserv_stat_content2 = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatImapAuthCommand"'.format(mx_account),0)

result_lists1 = stat_statistics.stat_statistic(imapserv_stat_content1,'[0]','StatImapAuthCommand',10)
result_lists2 = stat_statistics.stat_statistic(imapserv_stat_content2,'[0]','StatImapAuthCommand',5)

result_lists = result_lists1 + result_lists2
basic_function.summary(result_lists)
