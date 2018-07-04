#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##steps:
# (1) set keys:
#               /*/common/perfStatThresholds:[StatImapAuthCommand 0]
#               /*/common/reportParamsInterval: [30]  # default 60
#               /*/common/badPasswordDelay: [0]       # nodelay ,default 1
#               /*/common/maxBadPasswordDelay: [0]    # no delay,default 90 
# (2) create 10 accounts:testuser1@openwave.com -test10@openwave.com
# (3) clear current imapserv.stat file

import basic_function
import basic_class
import imap_operations
import global_variables
import remote_operations
import time

#print (global_variables.get_value('initialpath'))

#basic_class.mylogger_record.info('Runing setup testcase:mx-12528-imap_login_10_accounts_half_pass_half_fail')
basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx2_imap1_host_ip,mx2_mss1_host_ip,mx2_mta1_port,mx2_mta1_host_ip,mx2_host1_ip,mx2_pop1_port,mx2_pop1_host,mx2_imap1_port,mx2_imap1_host,mx1_mss1_host_ip,mx1_mss2_host_ip,mx1_imap1_host_ip,mx1_imap1_port,mx1_mta1_host_ip,mx1_mta1_port,mx1_pop1_host_ip,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx2_imap1_host_ip','mx2_mss1_host_ip','mx2_mta1_port','mx2_mta1_host_ip','mx2_host1_ip','mx2_pop1_port','mx2_pop1_host','mx2_imap1_port','mx2_imap1_host','mx1_mss1_host_ip','mx1_mss2_host_ip','mx1_imap1_host_ip','mx1_imap1_port','mx1_mta1_host_ip','mx1_mta1_port','mx1_pop1_host_ip','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')


basic_class.mylogger_record.info('step1:set keys')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=StatImapAuthCommand 0\";imconfcontrol -install -key \"/*/common/reportParamsInterval=30\";imconfcontrol -install -key \"/*/common/badPasswordDelay=0\";imconfcontrol -install -key \"/*/common/maxBadPasswordDelay=0\";imconfcontrol -install -key \"/*/imapserv/imapProxyHost=imap://{1}:{2}\";imconfcontrol -install -key \"/*/imapserv/imapProxyPort={2}\";imconfcontrol -install -key \"/*/common/loginAliases=true\"\''.format(mx_account,mx2_imap1_host,mx2_imap1_port),0)
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=StatImapAuthCommand 0\";imconfcontrol -install -key \"/*/common/reportParamsInterval=30\";imconfcontrol -install -key \"/*/common/badPasswordDelay=0\";imconfcontrol -install -key \"/*/common/maxBadPasswordDelay=0\";imconfcontrol -install -key \"/*/common/loginAliases=true\"\''.format(mx_account),0)


basic_class.mylogger_record.info('step2:create 10 accounts amd set proxy status of proxy server')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=10;i++));do account-create {1}$i@{2}   {1}$i default;done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Created Successfully',10)
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=10;i++));do account-create {1}$i@{2}   {1}$i default;done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Created Successfully',10)
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=10;i++));do imdbcontrol sac {1}$i {2} mailboxstatus P;done\''.format(mx_account,test_account_base,default_domain),0)

basic_class.mylogger_record.info('step3:create alias names for 10 accounts on procy server and dest server')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=10;i++));do imdbcontrol CreateAlias {1}$i u$i {2};done\''.format(mx_account,test_account_base,default_domain),0)
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=10;i++));do imdbcontrol CreateAlias {1}$i u$i {2};done\''.format(mx_account,test_account_base,default_domain),0)


time.sleep(30) # to avoid last operations not expires
basic_class.mylogger_record.info('step3: clear current imapserv.stat file')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)




