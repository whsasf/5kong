#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import basic_function
import basic_class
import imap_operations
import global_variables
import time
import remote_operations
import stat_statistics


basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')  
mx2_imap1_host_ip,mx2_mss1_host_ip,mx2_mta1_port,mx2_mta1_host_ip,mx2_host1_ip,mx2_pop1_port,mx2_pop1_host,mx2_imap1_port,mx2_imap1_host,mx1_mss1_host_ip,mx1_mss2_host_ip,mx1_imap1_host_ip,mx1_imap1_port,mx1_mta1_host_ip,mx1_mta1_port,mx1_pop1_host_ip,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx2_imap1_host_ip','mx2_mss1_host_ip','mx2_mta1_port','mx2_mta1_host_ip','mx2_host1_ip','mx2_pop1_port','mx2_pop1_host','mx2_imap1_port','mx2_imap1_host','mx1_mss1_host_ip','mx1_mss2_host_ip','mx1_imap1_host_ip','mx1_imap1_port','mx1_mta1_host_ip','mx1_mta1_port','mx1_pop1_host_ip','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')


basic_class.mylogger_record.info('step1:delete 6 accounts')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=6;i++));do account-delete {1}$i@{2};done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Deleted Successfully',6)
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'for ((i=1;i<=6;i++));do account-delete {1}$i@{2};done\''.format(mx_account,test_account_base,default_domain),1,'Mailbox Deleted Successfully',6)




basic_class.mylogger_record.info('step2:restore keys')
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/reportParamsInterval=60\";imconfcontrol -install -key \"/*/mta/subAddressAllowedIPs=127.0.0.1\";imconfcontrol -install -key \"/site1-inbound-standardmta-direct/mta/subAddressAllowedIPs=127.0.0.1\";imconfcontrol -install -key \"/*/common/perfStatThresholds=\";imconfcontrol -install -key \"/*/imapserv/imapProxyHost\";imconfcontrol -install -key \"/*/imapserv/imapProxyPort\";imconfcontrol -install -key \"/*/popserv/popProxyHost\";imconfcontrol -install -key \"/*/popserv/popProxyPort\"\''.format(mx_account),0)  
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/reportParamsInterval=60\";imconfcontrol -install -key \"/*/mta/subAddressAllowedIPs=127.0.0.1\";imconfcontrol -install -key \"/site1-inbound-standardmta-direct/mta/subAddressAllowedIPs=127.0.0.1\";imconfcontrol -install -key \"/*/common/perfStatThresholds=\"\''.format(mx_account),0)  
