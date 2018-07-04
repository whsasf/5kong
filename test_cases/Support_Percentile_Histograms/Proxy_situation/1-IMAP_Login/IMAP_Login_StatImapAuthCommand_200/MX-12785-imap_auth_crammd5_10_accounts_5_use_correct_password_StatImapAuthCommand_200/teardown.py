#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##steps:
# (1) delete accounts :testuser1@openwave.com - testuser10@openwave.com
# (2) restore the config keys:
#               /*/common/perfStatThresholds:[]
#               /*/common/reportParamsInterval: [60]     # default 60
#               /*/common/badPasswordDelay: [1]          # nodelay ,default 1
#               /*/common/maxBadPasswordDelay: [90]      # no delay,default 90 
#               /*/imapserv/allowCRAMMD5: [false]        # enable cram-md5
#               /*/mxos/defaultPasswordStoreType:[sha512]# default is sha512

import basic_function
import basic_class
import imap_operations
import global_variables
import remote_operations

mx2_imap1_host_ip,mx2_mss1_host_ip,mx2_mta1_port,mx2_mta1_host_ip,mx2_host1_ip,mx2_pop1_port,mx2_pop1_host,mx2_imap1_port,mx2_imap1_host,mx1_mss1_host_ip,mx1_mss2_host_ip,mx1_imap1_host_ip,mx1_imap1_port,mx1_mta1_host_ip,mx1_mta1_port,mx1_pop1_host_ip,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx2_imap1_host_ip','mx2_mss1_host_ip','mx2_mta1_port','mx2_mta1_host_ip','mx2_host1_ip','mx2_pop1_port','mx2_pop1_host','mx2_imap1_port','mx2_imap1_host','mx1_mss1_host_ip','mx1_mss2_host_ip','mx1_imap1_host_ip','mx1_imap1_port','mx1_mta1_host_ip','mx1_mta1_port','mx1_pop1_host_ip','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')


basic_class.mylogger_record.info('step1:delete 10 accounts')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=10;i++));do account-delete {1}$i@{2};done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Deleted Successfully',10)
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=10;i++));do account-delete {1}$i@{2};done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Deleted Successfully',10)


basic_class.mylogger_record.info('step2:restore config keys')

remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=\";imconfcontrol -install -key \"/*/common/reportParamsInterval=60\";imconfcontrol -install -key \"/*/common/badPasswordDelay=1\";imconfcontrol -install -key \"/*/common/maxBadPasswordDelay=90\";imconfcontrol -install -key \"/*/imapserv/imapProxyHost\";imconfcontrol -install -key \"/*/imapserv/imapProxyPort\";imconfcontrol -install -key \"/*/imapserv/allowCRAMMD5=false\";imconfcontrol -install -key \"/*/mxos/defaultPasswordStoreType=sha512\"\''.format(mx_account),0)
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=\";imconfcontrol -install -key \"/*/common/reportParamsInterval=60\";imconfcontrol -install -key \"/*/common/badPasswordDelay=1\";imconfcontrol -install -key \"/*/common/maxBadPasswordDelay=90\";imconfcontrol -install -key \"/*/imapserv/allowCRAMMD5=false\";imconfcontrol -install -key \"/*/mxos/defaultPasswordStoreType=sha512\"\''.format(mx_account),0)
