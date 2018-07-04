#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##steps:
# (1) set keys:
#               /*/common/perfStatThresholds:[StatPopPassCommand 200]
#               /*/common/reportParamsInterval: [30]  # default 60
#               /*/common/badPasswordDelay: [0]       # nodelay ,default 1
#               /*/common/maxBadPasswordDelay: [0]    # no delay,default 90 
# (2) create 10 accounts:testuser1@openwave.com -test10@openwave.com
# (3) clear current popserv.stat file

import basic_function
import basic_class
import imap_operations
import global_variables
import remote_operations
import time

#print (global_variables.get_value('initialpath'))

#basic_class.mylogger_record.info('Runing setup testcase:mx-11631-pop_login_10_accounts_half_pass_half_fail')
basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx1_pop1_host,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx1_pop1_host','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')


basic_class.mylogger_record.info('step1:set keys')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=StatPopPassCommand 200\";imconfcontrol -install -key \"/*/common/reportParamsInterval=30\";imconfcontrol -install -key \"/*/common/badPasswordDelay=0\";imconfcontrol -install -key \"/*/common/maxBadPasswordDelay=0\"\''.format(mx_account),0)

basic_class.mylogger_record.info('step2:create 10 accounts')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=10;i++));do account-create {1}$i@{2}   {1}$i default;done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Created Successfully',10)

time.sleep(30) # to avoid last operations not expires
basic_class.mylogger_record.info('step3: clear current popserv.stat file')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)




