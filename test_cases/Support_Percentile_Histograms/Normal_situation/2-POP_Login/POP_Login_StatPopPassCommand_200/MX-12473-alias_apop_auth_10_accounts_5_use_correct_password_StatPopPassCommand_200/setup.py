#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##steps:
# (1) set keys:
#               /*/common/perfStatThresholds:[StatPopPassCommand 200]
#               /*/common/reportParamsInterval: [30]       # default 60
#               /*/common/badPasswordDelay: [0]            # nodelay ,default 1
#               /*/common/maxBadPasswordDelay: [0]         # no delay,default 90 
#               /*/common/loginAliases: [true]             # false by default
#               /*/popserv/allowAPOP: [true]               # enable apop ,default false
#               /*/mxos/defaultPasswordStoreType: [clear]  # default is sha512, must use clear for apop 
#               /*/mxos/trustedClient: [true]              # to avoid use full account name(with domain) in apop auth,default is false

# (2) create 10 accounts:testuser1@openwave.com -test10@openwave.com
# (3) create alias for each account
# (4) clear current popserv.stat file

import basic_function
import basic_class
import imap_operations
import global_variables
import remote_operations
import time

#print (global_variables.get_value('initialpath'))

#basic_class.mylogger_record.info('Runing setup testcase:mx-11473-apop_alias_auth_10_accounts_half_pass_half_fail')
basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx1_mxos_host1_ip,mx1_mxos_host2_ip,mx1_popserv_host1,mx1_popserv_host1_pop3Port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,mx1_default_domain = \
global_variables.get_values('mx1_mxos_host1_ip','mx1_mxos_host2_ip','mx1_popserv_host1','mx1_popserv_host1_pop3Port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','mx1_default_domain')


basic_class.mylogger_record.info('step1:set keys')
remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=StatPopPassCommand 200\";imconfcontrol -install -key \"/*/common/reportParamsInterval=30\";imconfcontrol -install -key \"/*/common/badPasswordDelay=0\";imconfcontrol -install -key \"/*/common/maxBadPasswordDelay=0\";imconfcontrol -install -key \"/*/common/loginAliases=true\";imconfcontrol -install -key \"/*/popserv/allowAPOP=true\";imconfcontrol -install -key \"/*/mxos/defaultPasswordStoreType=clear\";imconfcontrol -install -key \"/*/mxos/trustedClient=true\"\''.format(mx_account),root_account,root_passwd,0)

basic_class.mylogger_record.info('step2:create 10 accounts')
remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'for ((i=1;i<=10;i++));do account-create {1}$i@{2}   {1}$i default;done\''.format(mx_account,test_account_base,mx1_default_domain),root_account,root_passwd,1,'Mailbox Created Successfully',10)

basic_class.mylogger_record.info('step3:create alias account for 20 accounts')
remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'for ((i=1;i<=10;i++));do imdbcontrol CreateAlias {1}$i u$i {2};done\''.format(mx_account,test_account_base,mx1_default_domain),root_account,root_passwd,0)
remote_operations.remote_operation(mx1_mxos_host2_ip,'su - {0} -c "~/lib/imservctrl killStart mxos"'.format(mx_account),root_account,root_passwd,0)
remote_operations.remote_operation(mx1_mxos_host1_ip,'su - {0} -c "~/lib/imservctrl killStart mss mxos"'.format(mx_account),root_account,root_passwd,0)

time.sleep(200) # to avoid last operations not expires
basic_class.mylogger_record.info('step4: clear current popserv.stat file')
remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c "> log/popserv.stat"'.format(mx_account),root_account,root_passwd,0)
