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

mx1_imap1_host_ip,mx1_imap1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx1_imap1_host_ip','mx1_imap1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')


for i in range(1,6): 
    mximap1 = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    try:
        mximap1.imap_authenticate('u'+str(i)+'@'+default_domain,test_account_base+str(i)) # using correct passwd
        basic_class.mylogger_record.info('imap alias auth_plain success')
    except:
        basic_class.mylogger_record.error('imap alias auth_plain fail')
    mximap1.imap_select()
    mximap1.imap_logout()

for i in range(6,11): 
    mximap2 = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    try:
        mximap2.imap_authenticate('u'+str(i)+'@'+default_domain,'password') # using wrong passwd :password here
    except:
        basic_class.mylogger_record.error('imap alias auth_plain fail')
    mximap2.imap_logout()
    
#step 2
basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('step2:check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatImapAuthCommand"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatImapAuthCommand',10)

basic_function.summary(result_lists)