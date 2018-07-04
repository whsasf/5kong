#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import basic_function
import basic_class
import pop_operations
import global_variables
import time
import remote_operations
import stat_statistics

basic_class.mylogger_record.debug('Preparing... get some variables needed for tests')                                                               
                                                                                                                                                    
mx2_imap1_host_ip,mx2_mss1_host_ip,mx2_mta1_port,mx2_mta1_host_ip,mx2_host1_ip,mx2_pop1_port,mx2_pop1_host,mx2_imap1_port,mx2_imap1_host,mx1_mss1_host_ip,mx1_mss2_host_ip,mx1_imap1_host_ip,mx1_imap1_port,mx1_mta1_host_ip,mx1_mta1_port,mx1_pop1_host_ip,mx1_pop1_port,mx_account,mx1_host1_ip,root_account,root_passwd,test_account_base,default_domain = \
global_variables.get_values('mx2_imap1_host_ip','mx2_mss1_host_ip','mx2_mta1_port','mx2_mta1_host_ip','mx2_host1_ip','mx2_pop1_port','mx2_pop1_host','mx2_imap1_port','mx2_imap1_host','mx1_mss1_host_ip','mx1_mss2_host_ip','mx1_imap1_host_ip','mx1_imap1_port','mx1_mta1_host_ip','mx1_mta1_port','mx1_pop1_host_ip','mx1_pop1_port','mx_account','mx1_host1_ip','root_account','root_passwd','test_account_base','default_domain')



basic_class.mylogger_recordnf.title('PART2:POP Message bodyRetrieval--StatMSSRetrMsg')
basic_class.mylogger_recordnf.title('StatMSSRetrMsg=200')  
basic_class.mylogger_record.info('set keys:StatMSSRetrMsg=200')  
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=StatMSSRetrMsg 200\"\''.format(mx_account),0)

remote_operations.remote_operation(mx2_mss1_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart popserv"'.format(mx_account),0)
time.sleep(50)


#1#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12765:StatMSSRetrMsg_200_pop_retr_same_normal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_retr(2)
    mypop3.pop_retr(2)
    mypop3.pop_retr(2)
    mypop3.pop_retr(2)
    mypop3.pop_retr(2)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[200]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12765:StatMSSRetrMsg_200_pop_retr_same_normal_message_for_5_times')


#2#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12766:StatMSSRetrMsg_200_pop_retr_different_normal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_retr(1)
    mypop3.pop_retr(2)
    mypop3.pop_retr(3)
    mypop3.pop_retr(4)
    mypop3.pop_retr(5)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[200]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12766:StatMSSRetrMsg_200_pop_retr_different_normal_message_for_5_times')



#3#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12767:StatMSSRetrMsg_200_pop_retr_same_abnormal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[200]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12767:StatMSSRetrMsg_200_pop_retr_same_abnormal_message_for_5_times')


#4#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12768:StatMSSRetrMsg_200_pop_retr_mixed_abnormal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_retr(5)
    mypop3.pop_retr(5)
    mypop3.pop_retr(6)
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[200]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12768:StatMSSRetrMsg_200_pop_retr_mixed_abnormal_message_for_5_times')



#5#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12769:StatMSSRetrMsg_200_pop_top_same_normal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_top(1,1)
    mypop3.pop_top(1,10)
    mypop3.pop_top(1,1)
    mypop3.pop_top(1,10)
    mypop3.pop_top(1,10)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[200]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12769:StatMSSRetrMsg_200_pop_top_same_normal_message_for_5_times')



#6#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12770:StatMSSRetrMsg_200_pop_top_different_normal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_top(1,1)
    mypop3.pop_top(2,10)
    mypop3.pop_top(3,1)
    mypop3.pop_top(4,10)
    mypop3.pop_top(5,10)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[200]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12770:StatMSSRetrMsg_200_pop_top_different_normal_message_for_5_times')



#7#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12771:StatMSSRetrMsg_200_pop_top_same_abnormal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_top(6,1)
    mypop3.pop_top(6,10)
    mypop3.pop_top(6,1)
    mypop3.pop_top(6,10)
    mypop3.pop_top(6,10)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[200]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12771:StatMSSRetrMsg_200_pop_top_same_abnormal_message_for_5_times')


#8#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12772:StatMSSRetrMsg_200_pop_top_mixed_abnormal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_top(3,1)
    mypop3.pop_top(4,10)
    mypop3.pop_top(6,1)
    mypop3.pop_top(6,10)
    mypop3.pop_top(7,10)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[200]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12772:StatMSSRetrMsg_200_pop_top_mixed_abnormal_message_for_5_times')



basic_class.mylogger_recordnf.title('StatMSSRetrMsg=0')  
basic_class.mylogger_record.info('set keys:StatMSSRetrMsg=0')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c \'imconfcontrol -install -key \"/*/common/perfStatThresholds=StatMSSRetrMsg 0\"\''.format(mx_account),0)

remote_operations.remote_operation(mx2_mss1_host_ip,root_account,root_passwd,'su - {0} -c "~/lib/imservctrl killStart popserv"'.format(mx_account),0)
time.sleep(50)




#9#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12773:StatMSSRetrMsg_0_pop_retr_same_normal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_retr(2)
    mypop3.pop_retr(2)
    mypop3.pop_retr(2)
    mypop3.pop_retr(2)
    mypop3.pop_retr(2)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[0]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12773:StatMSSRetrMsg_0_pop_retr_same_normal_message_for_5_times')


#10#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12774:StatMSSRetrMsg_0_pop_retr_different_normal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_retr(1)
    mypop3.pop_retr(2)
    mypop3.pop_retr(3)
    mypop3.pop_retr(4)
    mypop3.pop_retr(5)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[0]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12774:StatMSSRetrMsg_0_pop_retr_different_normal_message_for_5_times')



#11#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12775:StatMSSRetrMsg_0_pop_retr_same_abnormal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[0]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12775:StatMSSRetrMsg_0_pop_retr_same_abnormal_message_for_5_times')


#12#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12776:StatMSSRetrMsg_0_pop_retr_mixed_abnormal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_retr(5)
    mypop3.pop_retr(5)
    mypop3.pop_retr(6)
    mypop3.pop_retr(7)
    mypop3.pop_retr(7)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[0]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12776:StatMSSRetrMsg_0_pop_retr_mixed_abnormal_message_for_5_times')



#13#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12777:StatMSSRetrMsg_0_pop_top_same_normal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_top(1,1)
    mypop3.pop_top(1,10)
    mypop3.pop_top(1,1)
    mypop3.pop_top(1,10)
    mypop3.pop_top(1,10)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[0]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12777:StatMSSRetrMsg_0_pop_top_same_normal_message_for_5_times')



#14#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12778:StatMSSRetrMsg_0_pop_top_different_normal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_top(1,1)
    mypop3.pop_top(2,10)
    mypop3.pop_top(3,1)
    mypop3.pop_top(4,10)
    mypop3.pop_top(5,10)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[0]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12778:StatMSSRetrMsg_0_pop_top_different_normal_message_for_5_times')



#15#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12779:StatMSSRetrMsg_0_pop_top_same_abnormal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_top(6,1)
    mypop3.pop_top(6,10)
    mypop3.pop_top(6,1)
    mypop3.pop_top(6,10)
    mypop3.pop_top(6,10)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[0]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12779:StatMSSRetrMsg_0_pop_top_same_abnormal_message_for_5_times')


#16#########################################################################################################################
basic_class.mylogger_recordnf.title('running testcase:MX-12780:StatMSSRetrMsg_0_pop_top_mixed_abnormal_message_for_5_times')
basic_class.mylogger_record.info('clear current popserv.stat file')
remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "> log/popserv.stat"'.format(mx_account),0)

for i in range(1,6):
    mypop3 = pop_operations.POP_Ops(mx1_pop1_host_ip,mx1_pop1_port)
    mypop3.pop_login(test_account_base+str(i),test_account_base+str(i))
    mypop3.pop_list()
    mypop3.pop_top(3,1)
    mypop3.pop_top(4,10)
    mypop3.pop_top(6,1)
    mypop3.pop_top(6,10)
    mypop3.pop_top(7,10)
    mypop3.pop_quit()

basic_class.mylogger_record.info('fetching popserv.stat ...')
time.sleep (50)
basic_class.mylogger_record.info('check and analyze popserv.stat file ...')
popserv_stat_content = remote_operations.remote_operation(mx2_host1_ip,root_account,root_passwd,'su - {0} -c "cat log/popserv.stat|grep StatMSSRetrMsg"'.format(mx_account),0)
result_lists = stat_statistics.stat_statistic(popserv_stat_content,'[0]','StatMSSRetrMsg',25)
basic_function.summary(result_lists,'MX-12780:StatMSSRetrMsg_0_pop_top_mixed_abnormal_message_for_5_times')
