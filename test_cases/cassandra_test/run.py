#!/usr/bin/env python3

# -*- coding: utf-8 -*- 
# this module contains the IMAP operation related classes and functions

import basic_function
import basic_class
import imap_operations
import smtp_operations
import global_variables
import remote_operations
import time

#print (global_variables.get_value('initialpath'))

#basic_class.mylogger_record.info('Runing setup testcase:mx-11632-pop_auth_plain_10_accounts_half_pass_half_fail')
basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')

mx1_pop1_host,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx1_pop1_host','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')


remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/mta/requireAuthentication=true\";imconfcontrol -install -key \"/inbound-standardmta-direct/mta/requireAuthentication=true\";imconfcontrol -install -key \"/*/mta/allowCRAMMD5=true\";imconfcontrol -install -key \"/*/mta/allowTLS=true\"\''.format(mx_account),0)
remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'~/lib/imservctrl killStart mta\''.format(mx_account),0)

remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imdbcontrol sac xx1 openwave.com mailsmtpauth 1\''.format(mx_account),0)

time.sleep(5)

mysmtp = smtp_operations.SMTP_OPs('10.49.58.239','20025')
#mysmtp.smtp_starttls()
mysmtp.smtp_set_debuglevel()
#mysmtp.smtp_ehlo()
#mysmtp.smtp_ehlo_or_helo_if_needed()
mysmtp.smtp_login('xx1','p')
#mysmtp.smtp_auth_login('xx1','p')
mysmtp.smtp_quit()


remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/mta/requireAuthentication=false\";imconfcontrol -install -key \"/inbound-standardmta-direct/mta/requireAuthentication=false\";imconfcontrol -install -key \"/*/mta/allowCRAMMD5=false\";imconfcontrol -install -key \"/*/mta/allowTLS=false\"\''.format(mx_account),0)
