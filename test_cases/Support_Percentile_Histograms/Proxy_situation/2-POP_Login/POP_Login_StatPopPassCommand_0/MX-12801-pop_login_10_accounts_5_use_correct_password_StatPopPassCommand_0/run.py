#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##steps:
# (1) imap login 5 accounts with correct credentials, the other 5 use wrong credentials
# (2) check and analyze popserv.stat file .make sure the total attempts are 20 ,and half passed ,half failed

import basic_function
import basic_class
import pop_operations
import global_variables
import time
import remote_operations
import stat_statistics


#step 1
basic_class.mylogger_record.info('step1:pop login:5 account with correct passwd, the other 5 use wrong pssswd')

mx2_imapserv_host1_ip,mx2_mss_host1_ip,mx2_mta_host1_SMTPPort,mx2_mta_host1_ip,mx2_host1_ip,mx2_popserv_host1_pop3Port,mx2_popserv_host1,mx2_imapserv_host1_imap4Port,mx2_imapserv_host1,mx1_mss_host1_ip,mx1_mss_host2_ip,mx1_imapserv_host1_ip,mx1_imapserv_host1_imap4Port,mx1_mta_host1_ip,mx1_mta_host1_SMTPPort,mx1_popserv_host1_ip,mx1_popserv_host1_pop3Port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,mx1_default_domain,mx2_default_domain = \
global_variables.get_values('mx2_imapserv_host1_ip','mx2_mss_host1_ip','mx2_mta_host1_SMTPPort','mx2_mta_host1_ip','mx2_host1_ip','mx2_popserv_host1_pop3Port','mx2_popserv_host1','mx2_imapserv_host1_imap4Port','mx2_imapserv_host1','mx1_mss_host1_ip','mx1_mss_host2_ip','mx1_imapserv_host1_ip','mx1_imapserv_host1_imap4Port','mx1_mta_host1_ip','mx1_mta_host1_SMTPPort','mx1_popserv_host1_ip','mx1_popserv_host1_pop3Port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','mx1_default_domain','mx2_default_domain')


for i in range(1,6): 
    mxpop1 = pop_operations.POP_Ops(mx1_popserv_host1_ip,mx1_popserv_host1_pop3Port)
    try:
        mxpop1.pop_login(test_account_base+str(i),test_account_base+str(i)) # using correct passwd
        basic_class.mylogger_record.info('pop login success')
    except:
        basic_class.mylogger_record.error('pop login fail')
    mxpop1.pop_stat()
    mxpop1.pop_quit()

for i in range(6,11): 
    mxpop2 = pop_operations.POP_Ops(mx1_popserv_host1_ip,mx1_popserv_host1_pop3Port)
    try:
        mxpop2.pop_login(test_account_base+str(i),'password') # using wrong passwd :password here
    except:
        basic_class.mylogger_record.error('pop login fail')
    mxpop2.pop_quit()
    
#step 2
basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('step2:check and analyze popserv.stat file ...')
flag,popserv_stat_content1 = remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c "cat log/popserv.stat|grep StatPopPassCommand"'.format(mx_account),root_account,root_passwd,0)
result_lists1 = stat_statistics.stat_statistic(popserv_stat_content1,'[0]','StatPopPassCommand',10)

flag,popserv_stat_content2 = remote_operations.remote_operation(mx2_host1_ip,'su - {0} -c "cat log/popserv.stat|grep StatPopPassCommand"'.format(mx_account),root_account,root_passwd,0)
result_lists2 = stat_statistics.stat_statistic(popserv_stat_content2,'[0]','StatPopPassCommand',5)

result_lists = result_lists1 + result_lists2
basic_function.summary(result_lists)