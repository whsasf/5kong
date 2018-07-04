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


# IMAP Message bodyRetrieval--StatMSSRetrMsg
basic_class.mylogger_recordnf.title('PART1:IMAP Message bodyRetrieval--StatMSSRetrMsg')
basic_class.mylogger_recordnf.title('StatMSSRetrMsg=200')  
basic_class.mylogger_record.info('set keys:StatMSSRetrMsg=200')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=StatMSSRetrMsg 200\"\''.format(mx_account),0)

remote_operations.remote_operation(mx2_mss1_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart imapserv"'.format(mx_account),0)
time.sleep(50)

 
#1#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12745:statMSSRetrMsg_200_imap_fetch_INBOX_1:5_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    myimap.imap_fetch('1:5','rfc822')
    myimap.imap_fetch('1:5','rfc822.text')
    myimap.imap_fetch('1:5','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',75)
basic_function.summary(result_lists,'MX-12745:statMSSRetrMsg_200_imap_fetch_INBOX_1:5_body')


#2#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12746:statMSSRetrMsg_200_imap_fetch_INBOX_1,3,4,5_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    myimap.imap_fetch('1,3,4,5','rfc822')
    myimap.imap_fetch('1,3,4,5','rfc822.text')
    myimap.imap_fetch('1,3,4,5','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',60)
basic_function.summary(result_lists,'MX-12746:statMSSRetrMsg_200_imap_fetch_INBOX_1,3,4,5_body')


#3#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:statMSSRetrMsg_200_MX-12747:imap_fetch_INBOX_2_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    myimap.imap_fetch('2','rfc822')
    myimap.imap_fetch('2','rfc822.text')
    myimap.imap_fetch('2','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',5)
basic_function.summary(result_lists,'MX-12747:statMSSRetrMsg_200_imap_fetch_INBOX_2_body')


#4#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12748:statMSSRetrMsg_200_imap_fetch_INBOX_1:*_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    try:
        myimap.imap_fetch('1:*','rfc822')
    except:
        pass
    try:
        myimap.imap_fetch('1:*','rfc822.text')
    except:
        pass
    try:
        myimap.imap_fetch('1:*','body[text]')
    except:
        pass
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',105)
basic_function.summary(result_lists,'MX-12748:statMSSRetrMsg_200_imap_fetch_INBOX_1:*_body')



#5#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:statMSSRetrMsg_200_MX-12749:imap_fetch_INBOX_7_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    try:
        myimap.imap_fetch('7','rfc822')
    except:
        pass
    try:
        myimap.imap_fetch('7','rfc822.text')
    except:
        pass
    try:
        myimap.imap_fetch('7','body[text]')
    except:
        pass
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',15)
basic_function.summary(result_lists,'MX-12749:statMSSRetrMsg_200_imap_fetch_INBOX_7_body')



#6#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12750:statMSSRetrMsg_200_imap_fetch_test_1:5_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    myimap.imap_fetch('1:5','rfc822')
    myimap.imap_fetch('1:5','rfc822.text')
    myimap.imap_fetch('1:5','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',75)
basic_function.summary(result_lists,'MX-12750:statMSSRetrMsg_200_imap_fetch_test_1:5_body')



#7#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12751:statMSSRetrMsg_200_imap_fetch_test_1,3,4,6_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    myimap.imap_fetch('1,3,4,6','rfc822')
    myimap.imap_fetch('1,3,4,6','rfc822.text')
    myimap.imap_fetch('1,3,4,6','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',60)
basic_function.summary(result_lists,'MX-12751:statMSSRetrMsg_200_imap_fetch_test_1,3,4,6_body')



#8#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12752:statMSSRetrMsg_200_imap_fetch_test_2_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    myimap.imap_fetch('2','rfc822')
    myimap.imap_fetch('2','rfc822.text')
    myimap.imap_fetch('2','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',5)
basic_function.summary(result_lists,'MX-12752:statMSSRetrMsg_200_imap_fetch_test_2_body')



#9#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12753:statMSSRetrMsg_200_imap_fetch_test_1:*_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    try:
        myimap.imap_fetch('1:*','rfc822')
    except:
        pass
    try:
        myimap.imap_fetch('1:*','rfc822.text')
    except:
        pass
    try:
        myimap.imap_fetch('1:*','body[text]')
    except:
        pass
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',120)
basic_function.summary(result_lists,'MX-12753:statMSSRetrMsg_200_imap_fetch_test_1:*_body')



#10#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12754:statMSSRetrMsg_200_imap_fetch_test_7_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    try:
        myimap.imap_fetch('7','rfc822')
    except:
        pass
    try:
        myimap.imap_fetch('7','rfc822.text')
    except:
        pass
    try:
        myimap.imap_fetch('7','body[text]')
    except:
        pass
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[200]','StatMSSRetrMsg',15)
basic_function.summary(result_lists,'MX-12754:statMSSRetrMsg_200_imap_fetch_test_7_body')


basic_class.mylogger_recordnf.title('StatMSSRetrMsg=0')
basic_class.mylogger_record.info('chang key to:StatMSSRetrMsg=0')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=StatMSSRetrMsg 0\"\''.format(mx_account),0)
remote_operations.remote_operation(mx2_mss1_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart imapserv"'.format(mx_account),0)

time.sleep(50)

#11#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12755:statMSSRetrMsg_0_imap_fetch_INBOX_1:5_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    myimap.imap_fetch('1:5','rfc822')
    myimap.imap_fetch('1:5','rfc822.text')
    myimap.imap_fetch('1:5','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',75)
basic_function.summary(result_lists,'MX-12755:statMSSRetrMsg_0_imap_fetch_INBOX_1:5_body')


#12#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12756:statMSSRetrMsg_0_imap_fetch_INBOX_1,3,4,5_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    myimap.imap_fetch('1,3,4,5','rfc822')
    myimap.imap_fetch('1,3,4,5','rfc822.text')
    myimap.imap_fetch('1,3,4,5','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',60)
basic_function.summary(result_lists,'MX-12756:statMSSRetrMsg_0_imap_fetch_INBOX_1,3,4,5_body')


#13#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12757:statMSSRetrMsg_0_imap_fetch_INBOX_2_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    myimap.imap_fetch('2','rfc822')
    myimap.imap_fetch('2','rfc822.text')
    myimap.imap_fetch('2','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',5)
basic_function.summary(result_lists,'MX-12757:statMSSRetrMsg_0_imap_fetch_INBOX_2_body')


#14#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12758:statMSSRetrMsg_0_imap_fetch_INBOX_1:*_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    try:
        myimap.imap_fetch('1:*','rfc822')
    except:
        pass
    try:
        myimap.imap_fetch('1:*','rfc822.text')
    except:
        pass
    try:
        myimap.imap_fetch('1:*','body[text]')
    except:
        pass
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',105)
basic_function.summary(result_lists,'MX-12758:statMSSRetrMsg_0_imap_fetch_INBOX_1:*_body')



#15#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12759:statMSSRetrMsg_0_imap_fetch_INBOX_7_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select()
    try:
        myimap.imap_fetch('7','rfc822')
    except:
        pass
    try:
        myimap.imap_fetch('7','rfc822.text')
    except:
        pass
    try:
        myimap.imap_fetch('7','body[text]')
    except:
        pass
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',15)
basic_function.summary(result_lists,'MX-12759:statMSSRetrMsg_0_imap_fetch_INBOX_7_body')



#16#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12760:statMSSRetrMsg_0_imap_fetch_test_1:5_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    myimap.imap_fetch('1:5','rfc822')
    myimap.imap_fetch('1:5','rfc822.text')
    myimap.imap_fetch('1:5','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',75)
basic_function.summary(result_lists,'MX-12760:statMSSRetrMsg_0_imap_fetch_test_1:5_body')



#17#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12761:statMSSRetrMsg_0_imap_fetch_test_1,3,4,6_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    myimap.imap_fetch('1,3,4,6','rfc822')
    myimap.imap_fetch('1,3,4,6','rfc822.text')
    myimap.imap_fetch('1,3,4,6','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',60)
basic_function.summary(result_lists,'MX-12761:statMSSRetrMsg_0_imap_fetch_test_1,3,4,6_body')



#18#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12762:statMSSRetrMsg_0_imap_fetch_test_2_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    myimap.imap_fetch('2','rfc822')
    myimap.imap_fetch('2','rfc822.text')
    myimap.imap_fetch('2','body[text]')
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',5)
basic_function.summary(result_lists,'MX-12762:statMSSRetrMsg_0_imap_fetch_test_2_body')



#19#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12763:statMSSRetrMsg_0_imap_fetch_test_1:*_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    try:
        myimap.imap_fetch('1:*','rfc822')
    except:
        pass
    try:
        myimap.imap_fetch('1:*','rfc822.text')
    except:
        pass
    try:
        myimap.imap_fetch('1:*','body[text]')
    except:
        pass
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',120)
basic_function.summary(result_lists,'MX-12763:statMSSRetrMsg_0_imap_fetch_test_1:*_body')



#20#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12764:statMSSRetrMsg_0_imap_fetch_INBOX_1:5_body')
basic_class.mylogger_record.info('clear current imapserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/imapserv.stat"'.format(mx_account),0)

for i in range(1,6):
    myimap = imap_operations.IMAP_Ops(mx1_imap1_host_ip,mx1_imap1_port)
    myimap.imap_login(test_account_base+str(i),test_account_base+str(i))
    myimap.imap_select('test')
    try:
        myimap.imap_fetch('7','rfc822')
    except:
        pass
    try:
        myimap.imap_fetch('7','rfc822.text')
    except:
        pass
    try:
        myimap.imap_fetch('7','body[text]')
    except:
        pass
    myimap.imap_logout()

basic_class.mylogger_record.info('fetching imapserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze imapserv.stat file ...')
imapserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/imapserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(imapserv_stat_content,'[0]','StatMSSRetrMsg',15)
basic_function.summary(result_lists,'MX-12764:statMSSRetrMsg_0_imap_fetch_test_7_body')

