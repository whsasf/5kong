#!/bin/bash 
############################################ All functions definitions starts from here ############################################################
##############Loading base_functions#########################
#The base_function catains:
    #function check_setup_type()
    #function create_headerfiles()
    #function end_time_tc()
    #function imsanity_version()
    #function prints()
    #function set_color()
    #function start_time_tc()
    #function summary()
    #function summary_imsanity()
    #function set_config_keys()
    #function  imboxmaint_fn()
. base_func.sh
##############Loading utility_functions######################
#The Utility_function catains:
    #function Utilities_TestScenarios()
    #function account_create_fn()
    #function account_delete_fn()
    #function imboxstats_fn ()
    #function immsgdelete_utility()
    #function immssdescms_utility()
    #function imfolderlist_utility()
    #function immsgdump_utility()
    #function immsgfind_utility()
    #function immsgtrace_utility()
    #function imboxattctrl_utility()
    #function imboxtest_utility()
    #function imcheckfq_utility()
. utility_func.sh


#declaration
echo
echo
echo
echo "**********Below are some declarations for this test script**************"
echo "***1-CTE: Content-Transfer-Encoding (appeas in firstline dara test part)"
echo "************************************************************************"
echo
echo
echo

#clear FEP logs
echo "******************clear FEP logs ************************"
> $INTERMAIL/log/imapserv.log
> $INTERMAIL/log/popserv.log
> $INTERMAIL/log/mta.log

function cleanup() {
								
	start_time_tc	
	rm -rf imapCapablity.log imapStatus.log			
	rm -rf config_output.txt large_msg log_account_create.txt log_imboxstats.txt mta_errors.txt popquit.txt folder.txt header3.txt
	rm -rf new_storedmessages.txt storedmessages.txt poplist.txt poplogin.txt popretrieve.txt popdelete.txt root.txt
	rm -rf popstat.txt popuidl.txt list.txt imaplist.txt imaplogin.txt imapfetch.txt imaplogout.txt imapselect.txt 
	rm -rf boxstats_Sanity1.txt imapstore.txt imapexpunge.txt  imapmove.txt  imapdelete.txt imapexamine.txt imapclose.txt
	rm -rf imapcreate.txt  folder.txt imapidle.txt immsgdelete.txt imapappend.txt boxcreate.txt imapsearch.txt change_pwd.txt
	rm -rf imapcopy.txt imapnoop1.txt imapnoop2.txt imapnoop3.txt imapcheck1.txt imapcheck2.txt imapcheck3.txt sac.txt
	rm -rf log_folderlist.txt log_account_delete.txt log_immsgdump.txt log_immsgfind.txt
	rm -rf log_immsgdelete.txt log_msgtrace.txt descms_Sanity1.txt domain.txt invalid_tag.txt alias.txt chckfq.txt gaf.txt
	rm -rf log_imboxatt.txt log_imboxatt_1.txt log_imboxtest.txt log_imcheckfq.txt imaprename.txt imfilter.txt imfilter1.txt 
	rm -rf check_server.txt set_cosattr.txt show_cos.txt special_delete.txt
	rm -rf log_immssdescms.txt descms_Sanity.txt log_immsgfind1.txt 
	rm -rf boxdelete_boxstats_check.txt boxstats.txt boxstats_Sanity155.txt check.txt del.ldif delete_result.txt add_result.txt add.ldif header1.txt header2.txt header3.txt imap_errors.txt imap.txt imapsort.txt log_account_delete.txt mail.txt modify.ldif modify_result.txt modify_result1.txt pop_errors.txt restart.txt result.txt search_result.txt server.txt server1.txt temporary.txt temporary1.txt verify_mbx_creat.txt automsg
  rm -rf imapthread.txt imapfetchsize.txt log_account_delete.txt log_imfolderlist.txt
	user_prefix=Sanity 
	
	prints "Deleting mailboxes..." "cleanup"
	start_time_tc "cleanup"
	for ((i=1;i<=22;i++))
	do
		eval user$i="$user_prefix$i"
		account_delete_fn "$user_prefix$i"	
	done
	check_countusers=$(imdbcontrol la | grep -i @ | grep -i Sanity | wc -l)
	check_countusers=`echo $check_countusers | tr -d " "` 
	if [ "$check_countusers" == "0" ]
	then
		prints "Users are deleted successfully" "cleanup" "2"
		Result="0"
		#echo "Users are deleted successfully" >> summary.log
	else
		prints "Users are not deleted,Expected was 22 however users deleted are $check_countusers.Please check manually" "cleanup" "1"
		Result="1"
		#echo "Users are not deleted,Expected was 22 however users deleted are $check_countusers.Please check manually" >> summary.log
	fi
	
	summary "Deleting users through account-delete" $Result
  imdbcontrol sca default mailfolderquota  "/ all,ageweeks,5"
	summary_imsanity 
		
}
# It is used to fetch the details of the stateless setup #
function stateless() {
		
	set_color "6"
	echo "------------------------------------------------------------"
	echo "|       SANITY TOOL FOR STATELESS/STATEFUL EMAILMx EDITION |"
	echo "|                  VERSION = $imsanity_version             |"
	echo "|          Created by EMAIL-MX Team and QA                 |"
	echo "------------------------------------------------------------"
	echo 
	echo "======================================================================"
	echo "IMSANITY TOOL STARTED AT ====> "`date`
	echo "======================================================================"
	echo
	set_color "1"
	echo "Before starting Imsanity your servers should be up."
	echo "Please check all points are mounted"
	echo "Please clear the logs and clean the cores before starting Imsanity"
	echo
	set_color "0"
	set_color "6"
	echo "Gathering information required to run this Sanity tool."
	echo "Please wait....."
	echo
	#site_clust=$(cat $INTERMAIL/config/config.db | grep -i statelessMSS | cut -d "/" -f2)
	#Site=$(cat $INTERMAIL/config/config.db | grep -i statelessMSS | cut -d "/" -f2 | cut -d "-" -f1)
	#Cluster=$(cat $INTERMAIL/config/config.db | grep -i statelessMSS | cut -d "/" -f2 | cut -d "-" -f2)
  site_clust=$(cat $INTERMAIL/config/config.db | grep clusterName|grep -v imboxmaint | cut -d "/" -f2)
	Site=$(cat $INTERMAIL/config/config.db | grep clusterName|grep -v imboxmaint | cut -d "/" -f2 | cut -d "-" -f1)
  Cluster=$(cat $INTERMAIL/config/config.db | grep clusterName|grep -v imboxmaint | cut -d "/" -f2 | cut -d "-" -f2)
  Nginx=$(cat $INTERMAIL/config/config.db | grep -i messageStoreHosts | cut -d "[" -f2 | cut -d "]" -f1)
	#FirstMSS=$(imconfget groupDefinition | grep "$site_clust" | cut -d ":" -f2 | cut -d " " -f1)
	#SecondMSS=$(imconfget groupDefinition | grep "$site_clust" | cut -d ":" -f2 | cut -d " " -f2)
	MTAHost=$(cat $INTERMAIL/config/config.db | grep -i mta_run | grep -i on |  cut -d "/" -f2| tail -1)
	SMTPPort=$(cat $INTERMAIL/config/config.db | grep -i smtpport | grep -v ssl | grep -v outbound | cut -d "[" -f2 | cut -d "]" -f1|head -1 | tail -1)
	POPHost=$(cat $INTERMAIL/config/config.db | grep -i popserv_run | grep -i on |  cut -d "/" -f2 | tail -1)
	POPPort=$(cat $INTERMAIL/config/config.db | grep -i pop3port | grep -v ssl | cut -d "[" -f2 | cut -d "]" -f1 | head -1)
	#IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imap4port | grep -v ssl | grep -v improxy | cut -d "[" -f2 | cut -d "]" -f1 | tail -1)
	IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run | grep -i on | cut -d "/" -f2)
	IMAPPort=$(cat $INTERMAIL/config/config.db | grep -i imap4port | grep -v ssl | grep -v improxy | cut -d "[" -f2 | cut -d "]" -f1 | head -1)
	BackendType=$(imconfget hostInfo | cut -d "=" -f2 | cut -d ":" -f1)
	BackendCluster=$(imconfget hostInfo | cut -d "=" -f2 | cut -d ":" -f2)
	BackendPort=$(imconfget hostInfo | cut -d "=" -f2 | cut -d ":" -f3)
	RMEPort=$(cat $INTERMAIL/config/config.db | grep -i extrmeport| cut -d "[" -f2 | cut -d "]" -f1)
	extHost=$(cat $INTERMAIL/config/config.db | grep -i extserv_run | grep -i on | cut -d "/" -f2)
	mxoshost_port=`imconfget mxOsServiceHost |grep default |awk '{print $2}'`
	mxoshost=`imconfget mxOsServiceHost |grep default |awk '{print $2}'|awk -F ":" '{print $1}'`
	mxosport=`imconfget mxOsServiceHost |grep default |awk '{print $2}'|awk -F ":" '{print $2}'`
	echo "============================================================"
	echo "Site            ==> "$Site
	echo "MSS Cluster     ==> "$Cluster
	echo "Nginx Host      ==> "$Nginx
	echo "DB Used         ==> "$BackendType
	echo "DB Cluster/Host ==> "$BackendCluster
	echo "DB Port         ==> "$BackendPort
	#get mss info
	msshosts=`imconfget -fullpath /*/common/groupDefinition  |head -2|tail -1|awk -F : '{print $2}'`
	number2=`echo $msshosts|wc -w`
	for (( i=1;i<=$number2;i++ ))
	do
	temp=`echo $msshosts|cut -d " " -f $i`
	echo "MSS-$i           ==> "$temp
	done
	#echo "MSS-1           ==> "$FirstMSS
	#echo "MSS-2           ==> "$SecondMSS
	echo "MTA Server      ==> "$MTAHost" Port ==> "$SMTPPort
	echo "POP Server      ==> "$POPHost" Port ==> "$POPPort
	echo "IMAP Server     ==> "$IMAPHost" Port ==> "$IMAPPort
	echo "MXOS Server     ==> "$mxoshost" Port ==> "$mxosport
	echo "============================================================"
	echo
	echo > summary.log
	TotalTestCases=0
	Pass=0
	Fail=0
	set_color "0"
	
	#call of function stateful_stateless for setup independent features
	stateful_stateless
}
function stateful_stateless() {
  echo "*************change key to:/*/mss/serviceBlackoutSeconds: [3]*****************"
  echo "*******to make operations work find after mss restart*************************"
  echo "*************will change back after testing***********************************"
	#change  /*/mss/serviceBlackoutSeconds: [1] 
	set_config_keys "/*/mss/serviceBlackoutSeconds" "3" "1"
	#sleep 3					
	#call function to create users and mail box
	if [ "$setuptype" == "stateless" ]
	then
		
	prints "=========================================" "createUsers_stateless"
	prints "Creating user and mail box" "createUsers_stateless"
	prints "=========================================" "createUsers_stateless" 
	
	createUsers_stateless	
	
	prints "=============End of Step=================" "createUsers_stateless" 
	
	elif [ "$setuptype" == "stateful" ]
	then
	#creation_mailbox_user_stateful
	Cluster=$MSSHost
	
	prints "=========================================" "createUsers_stateful" 
	prints "Creating user and mail box" "createUsers_stateful" 
	prints "=========================================" "createUsers_stateful" 
		
	createUsers_stateful	
	
	prints "=============End of Step=================" "createUsers_stateful" 
	fi	
	
	prints "=========================================" "MXVERSION" 
	prints "Checking server version" "MXVERSION"
	prints "=========================================" "MXVERSION" 
		
	MXVERSION 
	prints "=============End of Step=================" "MXVERSION" 
	
	
	prints "=========================================" "default_config_keys" 
	prints "Setting Default Config Keys" "default_config_keys"
	prints "=========================================" "default_config_keys" 
		
	default_config_keys 
	prints "=============End of Step=================" "default_config_keys" 
	
	prints "=========================================" "COS_TestScenarios" 
	prints "COS Related Test Scenarios" "COS_TestScenarios"
	prints "=========================================" "COS_TestScenarios" 
		
	COS_TestScenarios 
	prints "=============End of Step=================" "COS_TestScenarios" 
	
	
	
	prints "=========================================" "smtp_operation" 
	prints "SMTP Operations " "smtp_operation" 
	prints "=========================================" "smtp_operation" 
	#call function for smtp session
	
	smtp_operation
	
	prints "=============End of Step=================" "smtp_operation" 
	#call function for pop operations
	prints "=========================================" "pop_operations" 
	prints "POP Operations " "pop_operations" 
	prints "=========================================" "pop_operations" 
	
	pop_operations
	
	prints "=============End of Step=================" "pop_operations" 
	#call function for imap operations
	prints "=========================================" "imap_operations" 
	prints "IMAP Operations " "imap_operations" 
	prints "=========================================" "imap_operations" 
	
	imap_operations
	
	prints "=============End of Step=================" "imap_operations" 
	prints "=========================================" "imap_thread_operations" 
	prints "IMAP THREAD Operations " "imap_thread_operations" 
	prints "=========================================" "imap_thread_operations" 
	
	imap_thread_operations
	
	prints "=============End of Step=================" "imap_thread_operations" 
			##Fetch(envelope) in IMAP
		
		prints "=========================================" "ITS_1329310"
		prints "ITS 1329310 test case" "ITS_1329310"
		prints "=========================================" "ITS_1329310" 
		ITS_1329310 
		prints "=============End of Step=================" "ITS_1329310" 
		
				## immsgdelete utility for single message
		
		prints "=========================================" "ITS_1319590"
		prints "ITS 1319590 test case" "ITS_1319590"
		prints "=========================================" "ITS_1319590" 
		ITS_1319590
		prints "=============End of Step=================" "ITS_1319590" 
	
	
	
	#Testing of ldapadd 	
	prints "=========================================" "ldap_add_test" 
	prints "ldap test case" "ldap_add_test"
	prints "=========================================" "ldap_add_test" 
	ldap_add_test
	prints "=============End of Step=================" "ldap_add_test" 
		
	#Testing of ldapsearch 
		
	prints "=========================================" "ldap_search_utilty" 
	prints "ldap search utility test case" "ldap_search_utilty" 
	prints "=========================================" "ldap_search_utilty" 
	ldap_search_utilty
	prints "=============End of Step=================" "ldap_search_utilty" 
		
	#Testing of ldapmodify  
		
	prints "=========================================" "ldap_modify_utility" 
	prints "ldap modify utility test case" "ldap_modify_utility" 
	prints "=========================================" "ldap_modify_utility" 
	ldap_modify_utility
	prints "=============End of Step=================" "ldap_modify_utility" 
		
	#Testing of ldapdelete  
		
	prints "=========================================" "ldap_delete_utility" 
	prints "ldap delete utility test case" "ldap_delete_utility" 
	prints "=========================================" "ldap_delete_utility" 
	ldap_delete_utility
	prints "=============End of Step=================" "ldap_delete_utility" 
	#check for keepalive=1 Invalid key value] in mss log for IMAP
	prints "=========================================" "invalid_keyvalue_msslog_imap" 
	prints "Invalid key value checking with imap test case" "invalid_keyvalue_msslog_imap" 
	prints "=========================================" "invalid_keyvalue_msslog_imap" 
	invalid_keyvalue_msslog_imap 
	prints "=============End of Step=================" "invalid_keyvalue_msslog_imap"
	
	#check for keepalive=1 Invalid key value] in mss log for POP
	prints "=========================================" "invalid_keyvalue_msslog_pop" 
	prints "Invalid key value checking with pop test case" "invalid_keyvalue_msslog_pop" 
	prints "=========================================" "invalid_keyvalue_msslog_pop" 
	invalid_keyvalue_msslog_pop 
	prints "=============End of Step=================" "invalid_keyvalue_msslog_pop" 
	
	# Checking delivery of large messages and their retreival
		
	prints "=========================================" "large_msg_delivery" 
	prints "large mail delivery test case" "large_msg_delivery" 
	prints "=========================================" "large_msg_delivery" 
	large_msg_delivery
		
	prints "=============End of Step=================" "large_msg_delivery" 
	
	#Testing that no flags are set for messages when checked through imap in second consecutive session 
	prints "=========================================" "no_flag_msg" 
	prints "No flag set for a message test case" "no_flag_msg" 
	prints "=========================================" "no_flag_msg"  	
	no_flag_msg
	prints "=============End of Step=================" "no_flag_msg"
	
	#expunge of message ,cache inconsistence
	prints "=========================================" "expunge_cache_inconsistence" 
	prints "Expunge test case" "expunge_cache_inconsistence" 
	prints "=========================================" "expunge_cache_inconsistence" 
	expunge_cache_inconsistence 
	prints "=============End of Step=================" "expunge_cache_inconsistence"
	#check for uid and all
	prints "=========================================" "imap_uid_check_scenario" 
	prints "Checking for UID in IMAP" "imap_uid_check_scenario" 
	prints "=========================================" "imap_uid_check_scenario" 
	imap_uid_check_scenario	
	prints "=============End of Step=================" "imap_uid_check_scenario" 
					
	#test for account creation with mode M
	prints "=========================================" "account_mode_M" 
	prints "Set account mode M test case" "account_mode_M" 
	prints "=========================================" "account_mode_M" 
	account_mode_M 
	prints "=============End of Step=================" "account_mode_M"
				
	prints "=========================================" "stored_command_before_login" 
	prints "Stored command before login test case" "stored_command_before_login" 
	prints "=========================================" "stored_command_before_login" 
	stored_command_before_login
	prints "=============End of Step=================" "stored_command_before_login" 	
	#call function for Utilities TestScenarios
	prints "=========================================" "Utilities_TestScenarios" 
	prints "Utilities_TestScenarios " "Utilities_TestScenarios" 
	prints "=========================================" "Utilities_TestScenarios" 
	
	Utilities_TestScenarios
	prints "=============End of Step=================" "Utilities_TestScenarios" 
	
	# Different test cases 
	prints "=========================================" "password_change_ac" 
	prints "Password change for an account " "password_change_ac" 
	prints "=========================================" "password_change_ac" 
	
	password_change_ac
	prints "=============End of Step=================" "password_change_ac" 
	
	prints "=========================================" "create_alias" 
	prints "Create alias for an account" "create_alias" 
	prints "=========================================" "create_alias" 
	
	create_alias
	prints "=============End of Step=================" "create_alias" 
	
	prints "=========================================" "delete_alias" 
	prints "Delete alias for an account" "delete_alias" 
	prints "=========================================" "delete_alias" 
	
	delete_alias
	prints "=============End of Step=================" "delete_alias" 
	
	prints "=========================================" "multiple_alias" 
	prints "Multiple alias for an account" "multiple_alias" 
	prints "=========================================" "multiple_alias"
	
	multiple_alias
	prints "=============End of Step=================" "multiple_alias" 
	
	prints "=========================================" "create_remote_fwd" 
	prints "Create Account forward for an account" "create_remote_fwd" 
	prints "=========================================" "create_remote_fwd"
	
	create_remote_fwd
	prints "=============End of Step=================" "create_remote_fwd" 
	
	prints "=========================================" "list_account_fwd" 
	prints "List Account forward for an account" "list_account_fwd" 
	prints "=========================================" "list_account_fwd"
	list_account_fwd
	prints "=============End of Step=================" "list_account_fwd" 
	
	prints "=========================================" "delete_remote_fwd" 
	prints "Delete Account forward for an account" "delete_remote_fwd" 
	prints "=========================================" "delete_remote_fwd"
	
	delete_remote_fwd
	prints "=============End of Step=================" "delete_remote_fwd" 
	
	prints "=========================================" "default_domain" 
	prints "Default Domain" "default_domain" 
	prints "=========================================" "default_domain"
	
	default_domain
	prints "=============End of Step=================" "default_domain" 
	
	prints "=========================================" "change_smtp_add" 
	prints "Change the email address of an account" "change_smtp_add" 
	prints "=========================================" "change_smtp_add"
	
	change_smtp_add
	prints "=============End of Step=================" "change_smtp_add" 
	
	prints "=========================================" "imap_invalid_tag" 
	prints "Check for invalid tag in IMAP" "imap_invalid_tag" 
	prints "=========================================" "imap_invalid_tag"
	
	imap_invalid_tag
	prints "=============End of Step=================" "imap_invalid_tag" 
	
	prints "=========================================" "TC_create_domain" 
	prints "Check for invalid tag in IMAP" "TC_create_domain" 
	prints "=========================================" "TC_create_domain"
	
	TC_create_domain
	prints "=============End of Step=================" "TC_create_domain" 
	
	
	# Special delete test cases 
	
	prints "=========================================" "special_delete_config_keys_defaultexpiry" 
	prints "Special Delete Scenarios" "special_delete_config_keys_defaultexpiry" 
	prints "=========================================" "special_delete_config_keys_defaultexpiry"
	
	special_delete_config_keys_defaultexpiry
	prints "=============End of Step=================" "special_delete_config_keys_defaultexpiry" 
		
	prints "=========================================" "special_delete_config_keys_mss" 
	prints "Special Delete Scenarios" "special_delete_config_keys_mss" 
	prints "=========================================" "special_delete_config_keys_mss"
	
	special_delete_config_keys_mss
	prints "=============End of Step=================" "special_delete_config_keys_mss" 
		
	prints "=========================================" "special_delete_config_keys_imap" 
	prints "Special Delete Scenarios" "special_delete_config_keys_imap" 
	prints "=========================================" "special_delete_config_keys_imap"
	
	special_delete_config_keys_imap
	prints "=============End of Step=================" "special_delete_config_keys_imap" 
	
	prints "=========================================" "special_delete_config_keys_pop" 
	prints "Special Delete Scenarios" "special_delete_config_keys_pop" 
	prints "=========================================" "special_delete_config_keys_pop"
	
	special_delete_config_keys_pop
	prints "=============End of Step=================" "special_delete_config_keys_pop" 
	
	prints "=========================================" "TC_SpecialDelete_POP" 
	prints "Special Delete Scenarios" "TC_SpecialDelete_POP" 
	prints "=========================================" "TC_SpecialDelete_POP"
		
	TC_SpecialDelete_POP
	prints "=============End of Step=================" "TC_SpecialDelete_POP"
	
	prints "=========================================" "TC_SpecialDelete_IMAP" 
	prints "Special Delete Scenarios" "TC_SpecialDelete_IMAP" 
	
	prints "=========================================" "TC_SpecialDelete_IMAP"
	
	TC_SpecialDelete_IMAP
	prints "=============End of Step=================" "TC_SpecialDelete_IMAP"
	
	
	#logging_enhancement means there is fromport attribute beside fromhost attribute.this is 
	# a new feature in MX9.5 .
	prints "=========================================" "TC_logging_enhancement_imap"
	
	TC_logging_enhancement_imap
	prints "=============End of TC_logging_enhancement_imap=================" "TC_logging_enhancement_imap"
	
	prints "=========================================" "TC_logging_enhancement_pop"
	
	TC_logging_enhancement_pop
	prints "=============End of TC_logging_enhancement_imap=================" "TC_logging_enhancement_pop"
	
	prints "=========================================" "TC_logging_enhancement_smtp"
	
	TC_logging_enhancement_smtp
	prints "=============End of TC_logging_enhancement_smtp=================" "TC_logging_enhancement_smtp"
} 
#create users ,
function createUsers_stateless() {
	user_prefix=Sanity 
	
	prints "Creating mailboxes..." "Creation_mailbox_user"
	start_time_tc "createUsers_stateless_tc"
	for ((i=1;i<=22;i++))
	do
		eval user$i="$user_prefix$i"
		account_create_fn "$user_prefix$i"	
	done
	check_countusers=$(imdbcontrol la | grep -i @ | grep -i Sanity | wc -l)
	check_countusers=`echo $check_countusers | tr -d " "` 
	if [ "$check_countusers" == "22" ]
	then
		prints "$check_countusers Users are created successfully" "createUsers_stateless" "2"
		Result="0"
		echo "$check_countusers Users are created successfully" >> summary.log
	else
		prints "Users are not created,Expected was 22 however users created are $check_countusers.Please check manually" "createUsers_stateless" "1"
		Result="1"
		echo "Users are not created,Expected was 22 however users created are $check_countusers.Please check manually" >> summary.log
	fi
	
	summary "Creating users through account-create" $Result
	
}

function default_config_keys() {
	set_config_keys "/*/mta/listProcessingDisable" "false" 
	set_config_keys "/*/imapserv/enableSort" "true"
	set_config_keys "/*/mss/cassMsgFileMaxSizeInKB" "2097151"
  set_config_keys "/*/mta/maxMessageSizeInKB" "2097151"
	
}
 
#COS related functions
   
function TC_create_cos () {
	
	start_time_tc create_cos_tc
	
	#imdbcontrol CreateCos bogus >> debug.log
	curl -s -X PUT -H "Content-Type: application/x-www-form-urlencoded" "http://${mxoshost}:${mxosport}/mxos/cos/v2/bogus" >> debug.log
	newcos_name=$(imdbcontrol ListCosNames | grep "bogus" | wc -l)
	if [ "$newcos_name" == "1" ]
	then
		prints "Created COS 'bogus' successfully" "TC_create_cos" "2"
		Result="0"
	else
		prints "ERROR:Not able to create COS 'bogus'. Please check manually." "TC_create_cos" "1"
		Result="1"
	fi
	summary "COS:TC_create_cos" $Result
	#if newly created cos has mailrealm attributes, need add realm in config.db
	imdbcontrol showcos bogus|grep mailrealm >showcos.txt
	showcoscount=`grep mailrealm showcos.txt|wc -l`
	if [ $showcoscount -eq 1 ];then
	  #change  /*/mss/serviceBlackoutSeconds: [3] 
	  #set_config_keys "/*/mss/serviceBlackoutSeconds" "3" "1"
	  #sleep 3
		#add key "/*/mss/realmsLocal: [realm]"in config.db,need reatart mss
    set_config_keys "/*/mss/realmsLocal"  "realm"  "1"
  else
  	#change  /*/mss/serviceBlackoutSeconds: [3] 
	  #set_config_keys "/*/mss/serviceBlackoutSeconds" "3" "1"
	  #sleep 3
		#add key "/*/mss/realmsLocal: [realm]"in config.db,need reatart mss
    set_config_keys "/*/mss/realmsLocal"  ""  "1"
    sleep 3
	fi
}
#create newaccount using new created COS
function TC_create_newaccount_using_new_COS () {
	
	start_time_tc "TC_create_newaccount_using_new_COS"
	#create account using newy created COS
	account-create test99@openwave.com test99 bogus >> debug.log
	#imdbcontrol la
	newaccount_count=`imdbcontrol la | grep "test99@openwave.com" |wc -l`
	#echo "newaccount_count=${newaccount_count}"
	if [ "$newaccount_count" == "1" ]
	then
		prints "Created new account using COS 'bogus' successfully" "TC_create_newaccount_using_new_COS" "2"
		Result="0"
		
	else
		prints "ERROR:Not able to create new account using COS 'bogus'. Please check manually." "TC_create_newaccount_using_new_COS" "1"
		Result="1"
	fi
	summary "COS:TC_create_newaccount_using_new_COS" $Result
	#clear messages
	immsgdelete  test99@openwave.com -all
}

#newaccount SMTP test
function TC_newaccount_smtp_test () {
	
	start_time_tc "TC_newaccount_smtp_test"
	#send 2 messages to nwq-account
	#./sm.pl  -u test99@openwave.com   -c 2 1K
	mail_send "test99" "small" "2"	
	#imap fetch
	imboxstats test99@openwave.com >imboxstats.txt
	message_received=`cat imboxstats.txt |grep "Total Messages Stored"|awk -F ":"  '{print $2}'`
	message_received=`echo $message_received | tr -d " "`
	if [ "$message_received" == "2" ]
	then
		prints "New account SMTP test successfully" "TC_newaccount_smtp_test" "2"
		Result="0"
	else
		prints "ERROR:New account SMTP test failed. Please check manually." "TC_newaccount_smtp_test" "1"
		Result="1"
	fi
	summary "COS:TC_newaccount_smtp_test" $Result
}

#newaccount IMAP test
function TC_newaccount_imap_test () {
	
	start_time_tc "TC_newaccount_imap_test"
	#imap fetch
	imap_fetch "test99" "1" "rfc822"
	#newaccount_imapfetch=$(cat imapfetch.txt | grep -i "OK FETCH completed" | wc -l)
	#if [ "$newaccount_imapfetch" == "1" ]
	#then
	#	prints "New account IMAP test successfully" "TC_newaccount_imap_test" "2"
	#	Result="0"
	#else
	#	prints "ERROR:New account IMAP test failed. Please check manually." "TC_newaccount_imap_test" "1"
	#	Result="1"
	#fi
	summary "COS:TC_newaccount_imap_test" $Result
}

#newaccount POP test
function TC_newaccount_pop_test () {
	
	start_time_tc "TC_newaccount_pop_test"

	#POP retr
	pop_retrieve "test99" "1"
	#cat popretrieve.txt
	summary "COS:TC_newaccount_pop_test" $Result
}


#newaccount delete
function TC_delete_newaccount () {
	
	start_time_tc "TC_delete_newaccount"

	account-delete   test99@openwave.com >accountdel.txt
	accountdelflag=`grep "Deleted Successfully" accountdel.txt |wc -l`
	if [ $accountdelflag -eq 1 ];then
	Result=0
	else
	Result=1
	fi
	summary "COS:TC_delete_newaccount" $Result
}
  
   
function TC_delete_cos() {
	start_time_tc TC_delete_cos_tc
					
	imdbcontrol DeleteCos bogus >> debug.log
	deletecos_name=$(imdbcontrol ListCosNames | grep "bogus" | wc -l)
	if [ "$deletecos_name" == "0" ]
	then
		prints "COS 'bogus' is deleted successfully" "TC_delete_cos" "2"
		Result="0"
	else
		prints "ERROR:Not able to delete COS 'bogus'. Please check manually." "TC_delete_cos" "1"
		Result="1"
	fi
	summary "COS:TC_delete_cos" $Result
}

#testcase 13
function TC_show_defaultcos () {
    start_time_tc TC_show_cos_tc
				
	show_cosname=$(imdbcontrol ShowCos default | wc -l)
	if [ $show_cosname -gt 110 ]
	then
		prints "'Default' COS is shown successfully"  "TC_show_defaultcos" "2"
		Result="0"
	else
		prints "ERROR:Not able to see default COS. Please check manually." "TC_show_defaultcos" "1"
		Result="1"
	fi
	summary "COS:TC_show_defaultcos" $Result
}
function set_cos() {
	start_time_tc set_cos_tc
	
	user_name=$1
	cos_attribute_name=$2
	cos_value=$3
	
	imdbcontrol SetAccountCos $user_name openwave.com $cos_attribute_name $cos_value &> sac.txt
	imdbcontrol gaf $user_name openwave.com  &> gaf.txt
	check_cosadded=$(cat gaf.txt | grep -i $cos_attribute_name | cut -d ":" -f1)
	check_cosadded=`echo $check_cosadded | tr -d " "`
	
	check_valueadded=$(cat gaf.txt | grep -i $cos_attribute_name | cut -d ":" -f2 )
	check_valueadded=`echo $check_valueadded | tr -d " "`
	
	if [[ "$check_cosadded" == "$cos_attribute_name" && "$check_valueadded" == "$cos_value" ]]
	then
		prints "Cos $cos_attribute_name for $user_name is set successfully" "set_cos" "2"
		Result="0"
	else
		prints "Cos $cos_attribute_name for $user_name is not set" "set_cos" "1"
		prints "ERROR: Please check Manually." "set_cos" "1"
		Result="1"
	fi
}
function set_cos_attribute(){
	
	start_time_tc set_cos_attribute_tc
	
	classOfService=$1
	attribute=$2
	value=$3
	
	imdbcontrol SetCosAttribute "$classOfService" "$attribute" "$value" &> set_cosattr.txt
	
	imdbcontrol ShowCos $classOfService &> show_cos.txt
	
	check_cosattr=$(cat show_cos.txt | grep -i $attribute | cut -d ":" -f1 )
	check_cosattr=`echo $check_cosattr | tr -d " "`
	
	check_cosvalue=$(cat show_cos.txt | grep -i $attribute | cut -d ":" -f2)
	check_cosvalue=`echo $check_cosvalue | tr -d " "`
	
	if [[ "$check_cosattr" == "$attribute" && "$check_cosvalue" == "$value" ]]
	then
		prints "Cos attribute $attribute for $classOfService is set successfully" "set_cos_attribute" "2"
		Result="0"
	else
		prints "Cos attribute $attribute for $classOfService  is not set" "set_cos_attribute" "1"
		prints "ERROR: Please check Manually." "set_cos_attribute" "1"
		Result="1"
	fi
}
function COS_TestScenarios(){
	
	prints "=========================================" "TC_create_cos" 
	prints "COS_TestScenarios" "TC_create_cos" 
	TC_create_cos
	prints "=============END OF TC_create_cos =================" "TC_create_cos" 	
	
	
	prints "=========================================" "TC_create_newaccount_using_new_COS" 
	prints "COS_TestScenarios" "TC_create_newaccount_using_new_COS" 
	TC_create_newaccount_using_new_COS
	prints "=============END OF TC_create_newaccount_using_new_COS =================" "TC_create_newaccount_using_new_COS"
	
	prints "=========================================" "TC_newaccount_smtp_test" 
	prints "COS_TestScenarios" "TC_newaccount_smtp_test" 
		
	TC_newaccount_smtp_test
	prints "=============END OF TC_newaccount_smtp_test =================" "TC_newaccount_smtp_test" 
	
	prints "=========================================" "TC_newaccount_imap_test" 
	prints "COS_TestScenarios" "TC_newaccount_imap_test" 
		
	TC_newaccount_imap_test
	prints "=============END OF TC_newaccount_imap_test =================" "TC_newaccount_imap_test" 	
	
	prints "=========================================" "TC_newaccount_pop_test" 
	prints "COS_TestScenarios" "TC_newaccount_pop_test" 
		
	TC_newaccount_pop_test
	prints "=============END OF TC_newaccount_pop_test =================" "TC_newaccount_pop_test" 	
	
	
	prints "=========================================" "TC_delete_newaccount" 
	prints "COS_TestScenarios" "TC_delete_newaccount" 
	TC_delete_newaccount
	prints "=============END OF TC_delete_newaccount =================" "TC_delete_newaccount"
	
	
	prints "=========================================" "TC_delete_cos" 
	prints "COS_TestScenarios" "TC_delete_cos" 
		
	TC_delete_cos
	prints "=============END OF TC_delete_cos =================" "TC_delete_cos" 	
	
	prints "=========================================" "TC_show_defaultcos" 
	prints "COS_TestScenarios" "TC_show_defaultcos" 
		
	TC_show_defaultcos
	prints "=============END OF TC_show_defaultcos =================" "TC_show_defaultcos" 	
	
	
}
#Various test cases
#testcase 172
function password_change_ac() {
	
	start_time_tc password_change_ac_tc
		
	imdbcontrol setPassword $user11 openwave.com secret clear
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $user11\r\n" >&3
	echo -en "pass secret\r\n" >&3
	echo -en "list\r\n" >&3
	echo -en "retr 1\r\n" >&3
	echo -en "quit\r\n" >&3
	cat <& 3 &> change_pwd.txt
	check_newpwd=$(cat change_pwd.txt | grep "is welcome here" | wc -l)
	if [ "$check_newpwd" == "1" ]
	then
		prints "Password change successfully" "password_change_ac" "2"
		Result="0"
	else
		prints "ERROR:Password is not change successfully" "password_change_ac" "1"
		prints "ERROR: Please check Manually." "password_change_ac" "1"
		Result="1"
	fi
	echo "Password change succesfully to 'secret' for $user11" >> debug.log
	
	imdbcontrol setPassword $user11 openwave.com $user11 clear
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $user11\r\n" >&3
	echo -en "pass $user11\r\n" >&3
	echo -en "list\r\n" >&3
	echo -en "retr 1\r\n" >&3
	echo -en "quit\r\n" >&3
	cat <& 3 &> change_pwd.txt
	verify_newpwd=$(cat change_pwd.txt | grep "is welcome here" | wc -l)
	if [ "$verify_newpwd" == "1" ]
	then
		prints "Password reset succesfully" "password_change_ac" "2"
		Result="0"
	else
		prints "ERROR:Password is not reset succesfully" "password_change_ac" "1"
		prints "ERROR: Please check Manually." "password_change_ac" "1"	
		Result="1"
	fi
	echo "Password change succesfully back to '$user11' for $user11" >> debug.log
	summary "Password change" $Result
}
#testcase 173
function create_alias () {
	
	start_time_tc create_alias_tc
		
	imdbcontrol CreateAlias $user11 San11 openwave.com >> debug.log
	prints "Created Alias San11 for user $user11" "create_alias"
	imboxstats_fn "$user11" 
	msg_exists=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists=`echo $msg_exists | tr -d " "`
	
	mail_send "San11" "small" "1"					
	
	imboxstats_fn "$user11" 
	msg_exists_new=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new=`echo $msg_exists_new | tr -d " "`
	
	imboxstats_fn "San11" 
	msg_exists_new_alias=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new_alias=`echo $msg_exists_new_alias | tr -d " "`
	
	total_count=$(($msg_exists+1))
	
	if [[ "$msg_exists_new" == "$msg_exists_new_alias" && "$msg_exists_new_alias" == "$total_count" ]]
	then
		prints "Alias creation is working fine" "create_alias" "2"
		Result="0"
	else
		prints "ERROR:Alias creation is not working fine. Please restart manually." "create_alias" "1"
		Result="1"
	fi
					
	summary "Alias creation" $Result						
}
#testcase 174
function delete_alias () {
	
	start_time_tc
	
	imdbcontrol DeleteAlias San11 openwave.com > alias.txt
	
	msg_no=$(cat alias.txt | grep "ERROR" | wc -l)
	if [ "$msg_no" == "0" ]
	then
		prints "Alias deletion is working fine" "delete_alias" "2"
		Result="0"
	else
		prints "ERROR:Alias deletion is not working fine. Please restart manually." "delete_alias" "1"
		Result="1"
	fi
				
	summary "Alias deletion" $Result	
}
#testcase 175
function multiple_alias() {
	
	start_time_tc multiple_alias_tc
	
	imboxstats_fn "$user12" 
	msg_exists=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists=`echo $msg_exists | tr -d " "`
	
	imdbcontrol CreateAlias $user12 San12a openwave.com >> debug.log
	imdbcontrol CreateAlias $user12 San12b openwave.com >> debug.log
	imdbcontrol CreateAlias $user12 San12c openwave.com >> debug.log
	imdbcontrol CreateAlias $user12 San12d openwave.com >> debug.log
	
	imdbcontrol ListAliases $user12 openwave.com >> debug.log
	
	mail_send "San12a" "small" "1"			
	mail_send "San12b" "small" "1"			
	mail_send "San12c" "small" "1"			
	mail_send "San12d" "small" "1"			
	imboxstats_fn "$user12" 
	msg_exists_new=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new=`echo $msg_exists_new | tr -d " "`
	
	imboxstats_fn "San12a" 
	msg_exists_new_alias1=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new_alias1=`echo $msg_exists_new_alias1 | tr -d " "`
	
	imboxstats_fn "San12b" 
	msg_exists_new_alias2=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new_alias2=`echo $msg_exists_new_alias2 | tr -d " "`
	
	imboxstats_fn "San12c" 
	msg_exists_new_alias3=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new_alias3=`echo $msg_exists_new_alias3 | tr -d " "`
	
	imboxstats_fn "San12d" 
	msg_exists_new_alias4=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new_alias4=`echo $msg_exists_new_alias4 | tr -d " "`
	
	if [[ "$msg_exists_new" == "$msg_exists_new_alias1" && "$msg_exists_new_alias1" == "$msg_exists_new_alias2" && "$msg_exists_new_alias2" == "$msg_exists_new_alias3" && "$msg_exists_new_alias3" == "$msg_exists_new_alias4" ]]
	then
		prints "Multiple Alias creation is working fine" "multiple_alias" "2"
		Result="0"
	else
		prints "ERROR:Multiple Alias creation is not working fine. Please restart manually." "multiple_alias" "1"
		Result="1"
	fi
										
	imdbcontrol DeleteAlias San12a openwave.com >> debug.log
	imdbcontrol DeleteAlias San12b openwave.com >> debug.log
	imdbcontrol DeleteAlias San12c openwave.com >> debug.log
	imdbcontrol DeleteAlias San12d openwave.com >> debug.log
	
	check_deletealias=$(imdbcontrol ListAliases $user12 openwave.com)
	check_deletealias=`echo $check_deletealias | tr -d " "`
	
	 if [ "$check_deletealias" == "" ]
	 then
		prints "All the alias are deleted" "multiple_alias" "2"
	else
		prints "All the alias are not deleted" "multiple_alias" "1"
	fi
	summary "Multiple Alias-creation" $Result	
}
#testcase 176
function create_remote_fwd () {
	start_time_tc create_remote_fwd_tc
				
	imboxstats_fn "$user14" 
	msg_exists=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists=`echo $msg_exists | tr -d " "`
	
	imdbcontrol CreateRemoteForward $user13 openwave.com $user14@openwave.com >> debug.log
	imdbcontrol EnableForwarding $user13 openwave.com
	
	mail_send "$user13" "small" "2"			
	msg_fwd=$(imdbcontrol ListAccountForwards $user13 openwave.com | grep "$user14"| wc -l)
	
	imboxstats_fn "$user14" 
	msg_exists_new=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new=`echo $msg_exists_new | tr -d " "`
	
	total_count=$(($msg_exists+2))
	
	if [[ "$msg_fwd" == "1" && "$total_count" == "$msg_exists_new" ]]
	then
		prints "Create account forward is working fine" "create_remote_fwd" "2"
		Result="0"
	else
		prints "ERROR:Create account forward is not working fine. Please check manually." "create_remote_fwd" "1"
		Result="1"
	fi
	summary "Create remote forward for $user13 completed" $Result	
}
#testcase 177
function list_account_fwd() {
	
	start_time_tc list_account_fwd_tc
				
	msg_fwd=$(imdbcontrol ListAccountForwards $user13 openwave.com | grep "$user14"| wc -l)
	if [ "$msg_fwd" == "1" ]
	then
		prints "List account forward is working fine" "list_account_fwd" "2"
		Result="0"
	else
		prints "ERROR:List account forward is not working fine. Please restart manually." "list_account_fwd" "1"
		Result="1"
	fi
	summary "List account forward" $Result
}
#testcase 178
function delete_remote_fwd () {
	
	start_time_tc delete_remote_fwd_tc
	
	imdbcontrol DeleteRemoteForward $user13 openwave.com $user14@openwave.com
	msg_fwd=$(imdbcontrol ListAccountForwards $user13 openwave.com | grep "$user14"| wc -l)
	if [ "$msg_fwd" == "0" ]
	then
		prints "Delete account forward is working fine" "delete_remote_fwd" "2"
		Result="0"
	else
		prints "ERROR:Delete account forward is not working fine. Please check manually." "delete_remote_fwd" "1"
		Result="1"
	fi
	summary "Delete remote forward" $Result
}
#testcase 179
function default_domain () {
	start_time_tc  default_domain_tc
	
	msg=$(imdbcontrol GetDefaultDomain |grep "openwave.com" | wc -l)
	if [ "$msg" == "1" ]
	then
		prints "Default domain is openwave.com" "default_domain" "2"
		Result="0"
	else
		prints "ERROR:Default domain is not openwave.com. Please check manually." "default_domain" "1"
		Result="1"
	fi
	summary "Default domain" $Result
}
#testacase 180
function change_smtp_add() {
	start_time_tc change_smtp_add_tc
	
	imboxstats_fn "$user15" 
	msg_exists=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists=`echo $msg_exists | tr -d " "`
	
	imdbcontrol ModifyAccountSmtp $user15 openwave.com testuser openwave.com
	mail_send "testuser" "small" "2"			
	
	imboxstats_fn "testuser" 
	msg_exists_new=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new=`echo $msg_exists_new | tr -d " "`
	total_count=$(($msg_exists+2))
	
	if [ "$msg_exists_new" == "$total_count" ]
	then
		prints "Change of SMTP address is working fine" "change_smtp_add" "2"
		Result="0"
	else
		prints "ERROR:Change of SMTP address is not working fine. Please check manually." "change_smtp_add" "1"
		Result="1"
	fi
	imdbcontrol mas testuser openwave.com $user15 openwave.com >> debug.log						
	summary "Change of SMTP address" $Result
				
}
#testcase 181
function imap_invalid_tag() {
	
	start_time_tc imap_invalid_tag_tc
				
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user2 $user2\r\n" >&3
	echo -en "a select INBOX\r\n" >&3
	echo -en "fdg#@$%%  logout\r\n" >&3
	echo -en "a logout\r\n" >&3
	
	cat <&3 > invalid_tag.txt
	prints "+++++++++++++++++++++++++" "imap_invalid_tag" "debug"
	#echo
	invalid_count=$(cat invalid_tag.txt | grep "BAD Illegal character in tag" | wc -l)
	if [ "$invalid_count" == "1" ]
	then
		prints "Giving proper error message while wrong logout command" "imap_invalid_tag" "2"
		Result="0"
	else
		prints "ERROR:Not giving proper error message while wrong logout command. Please check manually." "imap_invalid_tag" "1"
		Result="1"
	fi
	summary "Error message while incorrect logout IMAP" $Result
}
#testcase 182
function TC_create_domain(){
	start_time_tc TC_create_domain_tc
	
	imdbcontrol cd imsanity.com  &>> trash
	imdbcontrol ld &> domain.txt
	
	check_domain=$(cat domain.txt | grep -i "imsanity.com"| wc -l )
	check_domain=`echo $check_domain | tr -d " "`
	if [ $check_domain == "1" ]
	then
		prints "Created new domain 'imsanity.com' " "TC_create_domain" "2"
		Result="0"
	else
		prints "ERROR: Not able to create new domain 'imsanity.com'" "TC_create_domain" "1"
		prints "ERROR: Please check Manually." "TC_create_domain" "1"
		Result="1"
	fi
	summary "Create domain" $Result
	
}
#SMTP related functions  
function mail_send() { 
				
	user_mail=$1
	mail_size=$2
	mail_count=$3
	
	imboxstats_fn "$user_mail" 
	check_msgcount=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	check_msgcount=`echo $check_msgcount | tr -d " "`
	prints "Message count for $user_mail at start is $check_msgcount " "imboxstats_fn" 
	#Information related to SMTP session			
	SUBJECT="Sanity Test"
	user_mail_name=$(whoami)
	MAILFROM=`imdbcontrol la | grep -i @ | grep -i $user_mail_name | cut -d ":" -f2 | cut -d "@" -f1`
	MAILFROM=`echo $MAILFROM | tr -d " "`
	
		
	if [ "$mail_size" == "small" ]
	then
		DATA="Test message for Sanity Tool"
                msgdata_size=`echo $DATA | wc -c`
	elif [ "$mail_size" == "large" ]
	then
		ls -lrtR $INTERMAIL/ > large_msg
		#DATA=`cat 10MB`
                DATA=`cat large_msg`
		msgdata_size=`ls -al large_msg | cut -d " " -f5`
	fi
        msgdata_size=`echo $msgdata_size | tr -d " "`	
	c="1"
	exec 3<>/dev/tcp/$MTAHost/$SMTPPort
		
	while [ $c -le $mail_count ]  
	do
		echo -en "MAIL FROM:$MAILFROM\r\n" >&3
		echo -en "RCPT TO:$user_mail\r\n" >&3
		echo -en "DATA\r\n" >&3
		echo -en "Subject: $SUBJECT\r\n\r\n" >&3
		echo -en "$DATA\r\n" >&3
		echo -en ".\r\n" >&3
		(( c++ ))
	done
	echo -en "QUIT\r\n" >&3
	cat <&3 >> debug.log
	imboxstats_fn "$user_mail" 
	new_check_msgcount=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	new_check_msgcount=`echo $new_check_msgcount | tr -d " "`
	total_msgcount=$(($check_msgcount+$mail_count))
	prints "Message count for $user_mail after sending $mail_count message is $total_msgcount " "imboxstats_fn" 
	prints "newcheck_msgcount is $new_check_msgcount" "imboxstats_fn" "debug"
	prints "total_msgcount is $total_msgcount" "imboxstats_fn" "debug" 
        let msg_seq_n1=${check_msgcount}+1
        msg_seq_n2=$new_check_msgcount
        exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
        echo -en "a login $user_mail $user_mail\r\n" >&3
        echo -en "a select inbox\r\n" >&3
        echo -en "a fetch ${msg_seq_n1}:${msg_seq_n2} rfc822.size\r\n" >&3
        echo -en "a logout\r\n" >&3
        cat <&3 > imapfetchsize.txt
        cat imapfetchsize.txt >> debug.log
        check_imapfetch=$(cat imapfetchsize.txt | grep '(RFC822.SIZE' | wc -l)
        check_imapfetch=`echo $check_imapfetch | tr -d " "`
        if [ "$check_imapfetch" == "$mail_count" ]
        then
                msg_min_size=`cat imapfetchsize.txt | grep '(RFC822.SIZE'| awk '{print $NF}'| sort| head -1| sed 's/).*//g'`
                if [ $msg_min_size -gt $msgdata_size ];then
                    prints "$mail_size Message to $user_mail delivered successfully" "mail_send" "2"
                    Result="0"
                else
                    prints "$mail_size Message to $user_mail delivered unsuccessfully" "mail_send" "1"
                    Result="1"
                fi
        else
                prints "-ERR IMAP Fetch command for msg is unsuccessful" "imap_fetch" "1"
                Result="1"
        fi
}
function mail_send_thread(){
        user_mail=$1
        mail_type=$2
        foldername=$3
        mail_parent=$4
        imboxstats_fn "$user_mail" 
        check_msgcount=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
        check_msgcount=`echo $check_msgcount | tr -d " "`
        prints "Message count for $user_mail at start is $check_msgcount " "imboxstats_fn" 
        user_mail_name=$(whoami)
        MAILFROM=`imdbcontrol la | grep -i @ | grep -i $user_mail_name | cut -d ":" -f2 | cut -d "@" -f1`
        MAILFROM=`echo $MAILFROM | tr -d " "`
        SUBJECT="Sanity test $check_msgcount"
        DATA="test message"
        if [ "$mail_type" == "REFERENCES" ];then        
            if [ "x$mail_parent" != "x" ];then
                let mail_seqn=${mail_parent}-1
        
                imfolderlist $user_mail@openwave.com -folder $foldername | grep -q "${mail_seqn}: Message-Id:"
                if [ $? -ne 0 ];then 
                    prints "ERROR:There is no Parent message $4" "mail_send_thread" "1"
                    Result="1"
                fi
              
        
             exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
             echo -en "a login $user_mail $user_mail\r\n" >&3
             echo -en "a select $foldername\r\n" >&3
             echo -en "a fetch ${mail_parent} BODY[HEADER.FIELDS (Message-Id references)]\r\n" >&3
             echo -en "a logout\r\n" >&3
             cat <&3 > imapfetch.txt 
             cat imapfetch.txt >> debug.log
   
             msgid=`cat imapfetch.txt |grep -i "Message-Id:" | cut -d ":" -f 2`
             msgid=`echo $msgid | tr -d " "`
             oldrefid=`cat imapfetch.txt | grep -i "REFERENCES:" | head -1 | cut -d ":" -f 2`
             oldrefid=`echo $oldrefid | tr -d " "`
             newrefid="${oldrefid}${msgid}"
             DATA="REFERENCES: ${newrefid}\r\nTest message"
            fi
        elif [ "$mail_type" == "ORDEREDSUBJECT" ];then
            if [ "x$mail_parent" != "x" ];then 
                let mail_seqn=${mail_parent}-1
                imfolderlist $user_mail@openwave.com -folder $foldername | grep "${mail_seqn}: Subject:"  &> log_imfolderlist.txt
                SUBJECT=`cat log_imfolderlist.txt | cut -d ":" -f 3`
            fi
        fi
        if [ "$foldername" == "INBOX" ];then
        #send msg
            exec 3<>/dev/tcp/$MTAHost/$SMTPPort
            echo -en "MAIL FROM:$MAILFROM\r\n" >&3
            echo -en "RCPT TO:$user_mail\r\n" >&3
            echo -en "DATA\r\n" >&3
            echo -en "Subject: $SUBJECT\r\n" >&3
            echo -en "$DATA\r\n" >&3
            echo -en ".\r\n" >&3
            echo -en "QUIT\r\n" >&3
            cat <&3 >> debug.log
        else
            imfolderlist $user_mail@openwave.com -folder $foldername &> log_imfolderlist.txt
            if cat log_imfolderlist.txt | grep -q "FLD_NOT_FOUND"
            then
                imap_create "$user_mail" "$foldername"
                result_create=$Result
                if [ $result_create -ne 0 ];then
                    prints "Create folder $foldername for $user_mail unsuccessfully" "imap_create" "1"
                    Result="1"
                
                fi
            fi
            msgtxt="TO:$user_mail\r\nMessage-ID: <message-append-id-$check_msgcount>\r\nSubject: $SUBJECT\r\n$DATA\r\n"
            msg_strip=`echo $msgtxt | sed -e 's#\\\r##g' -e 's#\\\n##g'` 
            msgch=`echo $msg_strip| wc -c`
            msgl=`echo -ne $msgtxt | wc -l`
            msgsize=$(($msgl*2 + $msgch))
            imap_append "$user_mail" "$foldername" "{$msgsize}" "$msgtxt"
            result_append=$Result
            if [ $result_append -ne 0 ];then
                prints "Message to $user_mail appened unsuccessfully" "imap_append" "1"
                Result=1
            fi
        fi       
        imboxstats_fn "$user_mail" 
        new_check_msgcount=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
        new_check_msgcount=`echo $new_check_msgcount | tr -d " "`
        total_msgcount=$(($check_msgcount+1))
        if [ "$new_check_msgcount" == "$total_msgcount" ];then
                 prints "Message to $user_mail delivered successfully" "mail_send_thread" "2"
                 Result="0"
        else 
                 prints "Unable to deliver Message to $user_mail " "mail_send_thread" "1"
                 Result="1"
        fi
}
function smtp_operation() {
	
	#taking start time of tc
	start_time_tc smtp_operation_tc 
	
	prints "=========================================" "SMTP_TestScenarios" 
	prints "SMTP Operations -SMTP_TestScenarios" "SMTP_TestScenarios" 
	
	SMTP_TestScenarios
	
	prints "=============END OF SMTP_TestScenarios =================" "SMTP_TestScenarios"
	
	## Check for mta errors in logs
	cat $INTERMAIL/log/mta.log| egrep -i "erro;|urgt;|fatl;" > mta_errors.txt
	err_count=$(cat $INTERMAIL/log/mta.log| egrep -i "erro;|urgt;|fatl;" | wc -l)
	if [ "$err_count" -gt "1" ]	
	then
	prints "Error found in mta.log. Please check debug.log" "smtp_operation" "1"
	else
	prints "No Error found in mta.log." "smtp_operation" "2"
	fi
	 
	prints "Errors logged in MTA Logs:" "smtp_operation" "debug" "1"
	prints "==========================" "smtp_operation" "debug" "1"
	cat mta_errors.txt >> debug.log
	prints "==========================" "smtp_operation" "debug" "1"
}
function SMTP_TestScenarios(){
	prints "=========================================" "TC_SMTP_sending_three_smallmessages" 
	prints "SMTP_TestScenarios" "TC_SMTP_sending_three_smallmessages" 
		
	TC_SMTP_sending_three_smallmessages
	prints "=============END OF TC_SMTP_sending_three_smallmessages =================" "TC_SMTP_sending_three_smallmessages" 	
	
	prints "=========================================" "TC_SMTP_sending_five_smallmessages" 
	prints "SMTP_TestScenarios" "TC_SMTP_sending_five_smallmessages" 
		
	TC_SMTP_sending_five_smallmessages
	prints "=============END OF TC_SMTP_sending_five_smallmessages =================" "TC_SMTP_sending_five_smallmessages" 
	
	
	prints "=========================================" "TC_SMTP_sending_seven_smallmessages" 
	prints "SMTP_TestScenarios" "TC_SMTP_sending_seven_smallmessages" 
		
	TC_SMTP_sending_seven_smallmessages
	prints "=============END OF TC_SMTP_sending_seven_smallmessages =================" "TC_SMTP_sending_seven_smallmessages" 
	
	prints "=========================================" "TC_SMTP_sending_one_largemessages" 
	prints "SMTP_TestScenarios" "TC_SMTP_sending_one_largemessages" 
		
	TC_SMTP_sending_one_largemessages
	prints "=============END OF TC_SMTP_sending_one_largemessages =================" "TC_SMTP_sending_one_largemessages" 
	
	}
# testcase 14
function TC_SMTP_sending_three_smallmessages(){
	
	start_time_tc SMTP_sending_three_messages_tc
	
	mail_send "$user1" "small" "3"
	summary "SMTP:TC_SMTP_sending_three_smallmessages" $Result
}
# testcase 15
function TC_SMTP_sending_five_smallmessages(){
	start_time_tc TC_SMTP_sending_five_smallmessages
	
	mail_send "$user2" "small" "5"
	summary "SMTP:TC_SMTP_sending_five_smallmessages" $Result
}
# testcase 16
function TC_SMTP_sending_seven_smallmessages(){
	start_time_tc TC_SMTP_sending_seven_smallmessages
	mail_send "$user3" "small" "7"
	
	summary "SMTP:TC_SMTP_sending_seven_smallmessages" $Result
}
# testcase 17
function TC_SMTP_sending_one_largemessages(){
	
	start_time_tc TC_SMTP_sending_one_largemessages
        imdbcontrol sac $user20 openwave.com mailquotamaxmsgkb 0
        imdbcontrol sac $user20 openwave.com mailquotatotkb 0
	mail_send "$user20" "large" "1"
	summary "SMTP:TC_SMTP_sending_one_largemessages" $Result
}
#POP related functions  
function pop_operations(){
		
	
	prints "=========================================" "pop_login" 
	prints "POP Operations -POP LOGIN " "pop_login" 
		
	pop_login
	
	prints "=============END OF POP LOGIN =================" "pop_login" 	
	
	
	prints "=========================================" "POP_TestScenarios" 
	prints "POP Operations -POP_TestScenarios " "POP_TestScenarios" 
	
	POP_TestScenarios 
	
	prints "============= End OF POP_TestScenarios =================" "POP_TestScenarios" 	
	
		
	prints "=========================================" "pop_delete" 
	prints "POP Operations -POP DELETE " "pop_delete" 
	
	mail_send "$user5" "small" "2"
	pop_delete "$user5"
	
	prints "============= End OF POP DELETE =================" "pop_delete" 
	
	prints "=========================================" "pop_stat" 
	prints "POP Operations -POP STAT " "pop_stat" 
	
	pop_stat "$user1"	
		
	prints "============= End OF POP STAT =================" "pop_stat" 
	
	prints "=========================================" "pop_uidl" 
	prints "POP Operations -POP UIDL " "pop_uidl" 
	
	pop_uidl "$user1" 
	
	prints "============= End OF POP UIDL =================" "pop_uidl"
}
# testcase 18
function pop_login(){
	#taking start time of tc
	start_time_tc pop_login_tc 
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $user1\r\n" >&3
	echo -en "pass $user1\r\n" >&3
	echo -en "quit\r\n" >&3
	
	cat <&3 > poplogin.txt
	cat poplogin.txt >> debug.log
	check_poplogin=$(cat poplogin.txt | grep -i "welcome here" | wc -l)
	if [ "$check_poplogin" == "1" ]
	then
		prints "POP Login is successful" "pop_login" "2"
		Result="0"
	else
		prints "-ERR POP Login is unsuccessful" "pop_login" "1"
		Result="1"
	fi
	summary "POP:TC_POP_Login" $Result
}
function pop_list(){
	#taking start time of tc
	start_time_tc pop_list_tc 
	popUser=$1
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $popUser\r\n" >&3
	echo -en "pass $popUser\r\n" >&3
	echo -en "list\r\n" >&3
	echo -en "quit\r\n" >&3
	
	cat <&3 > poplist.txt
	cat poplist.txt >> debug.log
	check_list=$(cat poplist.txt | grep -i "+OK" | grep -i "messages" | wc -l)
	check_list=`echo $check_list | tr -d " "`
	if [ "$check_list" == "1" ]
	then
		prints "POP list command for $popUser is successful" "pop_list" "2"
		Result="0"
	else
		prints "-ERR POP list command for $popUser is unsuccessful" "pop_list" "1"
		Result="1"
	fi
	
}
	
function pop_uidl(){
#taking start time of tc
	start_time_tc pop_uidl_tc 
	popUser=$1
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $popUser\r\n" >&3
	echo -en "pass $popUser\r\n" >&3
	echo -en "uidl 1\r\n" >&3
	echo -en "quit\r\n" >&3
	
	cat <&3 > popuidl.txt
	cat popuidl.txt >> debug.log
	check_uidl=$(cat popuidl.txt | grep -i "+OK 1" | grep -o "-" | wc -l)
	check_uidl=`echo $check_uidl| tr -d " "`
	if [ "$check_uidl" == "4" ]
	then
		prints "POP uidl command for $popUser is successful" "pop_uidl" "2"
		Result="0"
	else
		prints "-ERR POP uidl command for $popUser is unsuccessful" "pop_uidl" "1"
		Result="1"
	fi
}
   
function pop_retrieve(){
	#taking start time of tc
	start_time_tc pop_retrieve_tc 
	popUser=$1
	msgtoberetrieved=$2
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $popUser\r\n" >&3
	echo -en "pass $popUser\r\n" >&3
	echo -en "retr $msgtoberetrieved\r\n" >&3
	echo -en "quit\r\n" >&3
	
	cat <&3 > popretrieve.txt
	cat popretrieve.txt >> debug.log
	check_retr=$(cat popretrieve.txt | grep -i "+OK" | grep -i "octets" |wc -l)
	check_content=$(cat popretrieve.txt | grep -i "Test message for Sanity Tool" |wc -l)
	if [[ "$check_retr" == "1" && "$check_content" == "1" ]]
	then
		prints "POP retr command for $popUser is successful" "pop_retrieve" "2"
		Result="0"
	else
		prints "-ERR POP retr command for $popUser is unsuccessful" "pop_retrieve" "1"
		Result="1"
	fi
}
#testcase 25
function pop_delete(){
	
	#taking start time of tc
	start_time_tc pop_delete_tc 
	popUser=$1
	pop_list "$popUser"
	check_msgexists=$(cat poplist.txt | grep -i +OK | grep -i messages | cut -d " " -f2)
	check_msgexists=`echo $check_msgexists | tr -d " "`
		
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $popUser\r\n" >&3
	echo -en "pass $popUser\r\n" >&3
	echo -en "dele 1\r\n" >&3
	echo -en "list\r\n" >&3 
	echo -en "quit\r\n" >&3
	cat <&3 > list.txt
	
	check_msgexists_new=$(cat list.txt | grep -i +OK | grep -i messages | cut -d " " -f2)
	check_msgexists_new=`echo $check_msgexists_new | tr -d " "`
	
	cat list.txt >> debug.log
	total_msgleft=$(($check_msgexists-1))
	
	if [ "$total_msgleft" == "$check_msgexists_new" ] 
	then
		prints "POP dele command for $popUser is successful" "pop_delete" "2"
		Result="0"
	else
		prints "-ERR POP dele command for $popUser is unsuccessful" "pop_delete" "1"
		Result="1"
	fi
	summary "POP:TC_POP_Delete" $Result
}
#testcase 26
function pop_stat(){
	
	#taking start time of tc
	start_time_tc pop_stat_tc 
	popUser=$1
	
	pop_list "$popUser"
	check_msgexists=$(cat poplist.txt | grep -i +OK | grep -i messages | cut -d " " -f2)
	check_msgexists=`echo $check_msgexists | tr -d " "`
	
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $popUser\r\n" >&3
	echo -en "pass $popUser\r\n" >&3
	echo -en "stat\r\n" >&3
	echo -en "quit\r\n" >&3
	cat <&3 > popstat.txt
	
	check_msgstat=$(cat popstat.txt | grep -i "+OK" | grep -v "$popUser" | grep -v "POP3" | grep -v "PASS" | cut -d " " -f2)
	check_msgstat=`echo $check_msgstat | tr -d " "`
	check_sizestat=$(cat popstat.txt | grep -i "+OK" | grep -v "$popUser" | grep -v "POP3" | grep -v "PASS" | cut -d " " -f3)
	check_sizestat=`echo $check_sizestat | tr -d " "`
	
	
	if [ "$check_msgstat" == "$check_msgexists" ]
	then	
		total_msgsize=0
		for ((i=1; i<=check_msgexists;i++))
			do
				line_number=$(cat poplist.txt | cut -d " " -f1 | grep -i -n "$i" | cut -d ":" -f1)
				line_p="p"
				line=$line_number$line_p
				check_msgsize=$(sed -n $line poplist.txt | cut -d " " -f2)
				total_msgsize=$(($total_msgsize+${check_msgsize//$'\r'}))
			done
		total_msgsize=${total_msgsize//$'\r'}
		total_msgsize=`echo $total_msgsize | tr -d " "`
		check_sizestat=${check_sizestat//$'\r'}
		check_sizestat=`echo $check_sizestat | tr -d " "`
		
		if [ "$total_msgsize" == "$check_sizestat" ]
		then
			prints "POP stat command for $popUser  is successful" "pop_stat" "2"
			Result="0"
		else
			prints "-ERR POP stat command for $popUser is unsuccessful" "pop_stat" "1"
			Result="1"
		fi
	fi
	summary "POP:TC_POP_Stat" $Result
	cat popstat.txt >> debug.log
}
function POP_TestScenarios(){
	prints "=========================================" "TC_POP_List" 
	prints "POP_TestScenarios" "TC_POP_List" 
		
	TC_POP_List
	prints "=============END OF TC_POP_List =================" "TC_POP_List" 	
	
	prints "=========================================" "TC_POP_uidl" 
	prints "POP_TestScenarios" "TC_POP_uidl" 
		
	TC_POP_uidl
	prints "=============END OF TC_POP_uidl =================" "TC_POP_uidl" 	
	
	
	prints "=========================================" "TC_POP_retr_first_message" 
	prints "POP_TestScenarios" "TC_POP_retr_first_message" 
		
	TC_POP_retr_first_message
	prints "=============END OF TC_POP_retr_first_message =================" "TC_POP_retr_first_message" 	
	
	prints "=========================================" "TC_POP_retr_second_message" 
	prints "POP_TestScenarios" "TC_POP_retr_second_message" 
		
	TC_POP_retr_second_message
	prints "=============END OF TC_POP_retr_second_message =================" "TC_POP_retr_second_message" 	
	
	
	prints "=========================================" "TC_POP_retr_third_message" 
	prints "POP_TestScenarios" "TC_POP_retr_third_message" 
		
	TC_POP_retr_third_message
	prints "=============END OF TC_POP_retr_third_message =================" "TC_POP_retr_third_message" 	
	
	prints "=========================================" "TC_POP_quit_before_login" 
	prints "POP_TestScenarios" "TC_POP_quit_before_login" 
		
	TC_POP_quit_before_login
	prints "=============END OF TC_POP_quit_before_login =================" "TC_POP_quit_before_login"
	
	prints "=========================================" "TC_POP_quit_after_login" 
	prints "POP_TestScenarios" "TC_POP_quit_after_login" 
		
	TC_POP_quit_after_login
	prints "=============END OF TC_POP_quit_after_login =================" "TC_POP_quit_after_login"
	
	}
#testcase 19
function TC_POP_List(){
	start_time_tc TC_POP_List_tc
	
	pop_list "$user1" 
	summary "POP:TC_POP_List" $Result
}	

function TC_POP_uidl(){
	start_time_tc TC_POP_uidl_tc
	
	pop_uidl "$user1" 
	summary "POP:TC_POP_uidl" $Result
}	

#testcase 20
function TC_POP_retr_first_message(){
	start_time_tc TC_POP_retr_first_message_tc
  immsgdelete_utility "$user6" "-all"
	
	mail_send "$user6" "small" "3"
	pop_retrieve "$user6" "1"      
	summary "POP:TC_POP_retr_first_message" $Result
}
#testcase 21
function TC_POP_retr_second_message(){
	start_time_tc TC_POP_retr_second_message_tc
	
	pop_retrieve "$user6" "2"      
	summary "POP:TC_POP_retr_second_message" $Result
}
#testcase 22
function TC_POP_retr_third_message(){
	start_time_tc TC_POP_retr_third_message_tc
	
	pop_retrieve "$user6" "3"      
	summary "POP:TC_POP_retr_third_message" $Result
}
#testcase 23
function TC_POP_quit_before_login(){
	start_time_tc TC_POP_quit_tc
	
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "quit\r\n" >&3
	
	cat <&3 > popquit.txt
	cat popquit.txt >> debug.log
	check_popquit=$(cat popquit.txt | grep -i "+OK ? InterMail POP3 server signing off" | wc -l)
	if [ "$check_popquit" == "1" ]
	then
		prints "POP Quit is successful" "TC_POP_quit_before_login" "2"
		Result="0"
	else
		prints "-ERR POP Quit is unsuccessful" "TC_POP_quit_before_login" "1"
		Result="1"
	fi
	summary "POP:TC_POP_quit_before_login" $Result
}
# testcase24
function TC_POP_quit_after_login(){
	start_time_tc TC_POP_quit_tc
	
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $user1\r\n" >&3
	echo -en "pass $user1\r\n" >&3
	echo -en "quit\r\n" >&3
	
	cat <&3 > popquit.txt
	cat popquit.txt >> debug.log
	check_popquit=$(cat popquit.txt | grep -i "+OK $user1 InterMail POP3 server signing off" | wc -l)
	if [ "$check_popquit" == "1" ]
	then
		prints "POP Quit is successful" "TC_POP_quit_after_login" "2"
		Result="0"
	else
		prints "-ERR POP Quit is unsuccessful" "TC_POP_quit_after_login" "1"
		Result="1"
	fi
	summary "POP:TC_POP_quit_after_login" $Result
}
#IMAP related functions 
function imap_operations(){
	prints "=========================================" "imap_login" 
	prints "IMAP Operations -IMAP LOGIN" "imap_login" 
		
	imap_login
	prints "=============END OF IMAP LOGIN =================" "imap_login" 	
		
	
	prints "=========================================" "imap_list" 
	prints "IMAP Operations -IMAP LIST" "imap_list" 
		
	imap_list "$user2"
	prints "=============END OF IMAP LIST =================" "imap_list" 	
	
		
	prints "=========================================" "imap_select" 
	prints "IMAP Operations -IMAP SELECT" "imap_select" 
	
	imap_select "$user2"
	prints "=============END OF IMAP SELECT =================" "imap_select" 	
		
	
	prints "=========================================" "imap_fetch" 
	prints "IMAP Operations -IMAP FETCH" "imap_fetch" 	
		
	imap_fetch "$user2" "1" "rfc822.size" 
	prints "=============END OF IMAP FETCH =================" "imap_fetch"
	
	
	prints "=========================================" "imap_store" 
	prints "IMAP Operations -IMAP STORE" "imap_store" 
	
	imap_store "$user2" "3" "+" "\Deleted" "INBOX"
	prints "=============END OF IMAP STORE =================" "imap_store"
		
	
	prints "=========================================" "imap_expunge" 
	prints "IMAP Operations -IMAP EXPUNGE" "imap_expunge" 	
		
	imap_expunge "$user2"
	prints "=============END OF IMAP EXPUNGE =================" "imap_expunge"
		
	
	#prints "=========================================" "imap_copy" 
	#prints "IMAP Operations -IMAP COPY" "imap_copy" 	
		
	#imap_copy
	#prints "=============END OF IMAP COPY =================" "imap_copy"
	
	
	#prints "=========================================" "imap_move" 
	#prints "IMAP Operations -IMAP MOVE" "imap_move" 	
		
	#imap_move "$user2" "1" "SentMail"
	#prints "=============END OF IMAP MOVE =================" "imap_move"
	
	#prints "=========================================" "imap_create" 
	#prints "IMAP Operations -IMAP CREATE" "imap_create" 	
	
	#imap_create "$user5" "TMP"
	#prints "=============END OF IMAP CREATE =================" "imap_create"
	
	
	#prints "=========================================" "imap_delete" 
	#prints "IMAP Operations -IMAP DELETE" "imap_delete" 
	
	#imap_create "$user3" "TEMP"
	#imap_delete "$user3" "TEMP"
	#prints "=============END OF IMAP DELETE =================" "imap_delete"
	
	
	prints "=========================================" "imap_logout" 
	prints "IMAP Operations -IMAP LOGOUT" "imap_logout" 
		
	imap_logout
	prints "=============END OF IMAP LOGOUT =================" "imap_logout"
	prints "=========================================" "IMAP_TestScenarios" 
	prints "IMAP Operations -IMAP_TestScenarios" "IMAP_TestScenarios" 
	
	IMAP_TestScenarios
	
	prints "=============END OF IMAP_TestScenarios =================" "imap_logout"
	
	
}
#testcase 27
function imap_login(){
	start_time_tc imap_login_tc
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user2 $user2\r\n" >&3
	echo -en "a logout\r\n" >&3	
	
	cat <&3 > imaplogin.txt
	cat imaplogin.txt >> debug.log
	check_imaplogin=$(cat imaplogin.txt | grep -i "OK LOGIN completed" | wc -l)
	check_imaplogin=`echo $check_imaplogin | tr -d " "`
	
	if [ "$check_imaplogin" == "1" ]
	then
		prints "IMAP Login is successful" "imap_login" "2"
		Result="0"
	else
		prints "IMAP Login is unsuccessful" "imap_login" "1"
		Result="1"
	fi
	summary "IMAP:TC_IMAP_Login" $Result
}
 
function imap_list(){
	start_time_tc imap_list_tc
	
	imapUser=$1
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a list \"\" *\r\n" >&3
	echo -en "a logout\r\n" >&3	
	
	cat <&3 > imaplist.txt
	cat imaplist.txt >> debug.log
	check_imaplist=$(cat imaplist.txt | grep -i "OK LIST completed" | wc -l)
	check_imaplist=`echo $check_imaplist | tr -d " "`
	
	if [ "$check_imaplist" == "1" ]
	then
		prints "IMAP list command for $imapUser is successful" "imap_list" "2"
		Result="0"
	else
		prints "-ERR IMAP list command for $imapUser is unsuccessful" "imap_list" "1"
		Result="1"
	fi
}
function imap_select(){
	start_time_tc imap_select_tc
	imapUser=$1
	foldername=$2
	if [ "$2" == "" ]
	then
	foldername="INBOX"
	fi
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername\r\n" >&3
	echo -en "a logout\r\n" >&3	
	
	cat <&3 > imapselect.txt
	cat imapselect.txt >> debug.log
	check_imapselect=$(cat imapselect.txt | grep -i "SELECT completed" | wc -l)
	check_imapselect=`echo $check_imapselect | tr -d " "`
	
	if [ "$check_imapselect" == "1" ]
	then
		prints "IMAP select command for folder $foldername is successful" "imap_select" "2"
		Result="0"
	else
		prints "-ERR IMAP select command for $foldername is unsuccessful" "imap_select" "1"
		Result="1"
	fi
	
}
function imap_fetch(){
	start_time_tc imap_fetch_tc
	imapUser=$1
	msg_tobefetched=$2
	parameter_tobefetched=$3
	foldername=$4
	
	if [ "$3" == "" ]
	then
	parameter_tobefetched="rfc822"
	fi
	if [ "$4" == "" ]
	then
	foldername="INBOX"
	fi
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername\r\n" >&3
	echo -en "a fetch $msg_tobefetched $parameter_tobefetched\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapfetch.txt
	cat imapfetch.txt >> debug.log
	
	check_imapfetch=$(cat imapfetch.txt | grep -i "OK FETCH completed" | wc -l)
	check_imapfetch=`echo $check_imapfetch | tr -d " "`
	if [ "$check_imapfetch" == "1" ]
	then
		prints "IMAP Fetch command for $parameter_tobefetched for $imapUser is successful" "imap_fetch" "2"
		Result="0"
	else
		prints "-ERR IMAP Fetch command for $parameter_tobefetched for $imapUser is unsuccessful" "imap_fetch" "1"
		Result="1"
	fi
	
}

function imap_uid_fetch(){
	start_time_tc imap_uid_fetch_tc
	imapUser=$1
	msg_tobefetched=$2
	parameter_tobefetched=$3
	foldername=$4
	
	if [ "$3" == "" ]
	then
	parameter_tobefetched="rfc822"
	fi
	if [ "$4" == "" ]
	then
	foldername="INBOX"
	fi
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername\r\n" >&3
	echo -en "a uid fetch $msg_tobefetched $parameter_tobefetched\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapuidfetch.txt
	cat imapuidfetch.txt >> debug.log
	
	check_imapuidfetch=$(cat imapuidfetch.txt | grep -i "OK UID FETCH completed" | wc -l)
	check_imapuidfetch=`echo $check_imapuidfetch | tr -d " "`
	if [ "$check_imapuidfetch" == "1" ]
	then
		prints "IMAP UID Fetch command for $parameter_tobefetched for $imapUser is successful" "imap_uid_fetch" "2"
		Result="0"
	else
		prints "-ERR IMAP UID Fetch command for $parameter_tobefetched for $imapUser is unsuccessful" "imap_uid_fetch" "1"
		Result="1"
	fi
	
}
function imap_store(){
	start_time_tc imap_store_tc
	
	imapUser=$1
	msg_tobeflagged=$2
	option=$3
	flagname=$4
	foldername=$5
	flags="flags"
	parameter=$option$flags
	
	if [ "$3" == "+" ]
	then
	stringused="Added"
	else
	stringused="Removed"
	fi
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername\r\n" >&3
	echo -en "a store 1:$msg_tobeflagged $parameter $flagname\r\n" >&3
	echo -en "a logout\r\n" >&3
	
	cat <&3 > imapstore.txt
	cat imapstore.txt >> debug.log
	
	check_imapstore=$(cat imapstore.txt | grep -i "OK STORE completed" | wc -l)
	check_imapstore=`echo $check_imapstore | tr -d " "`
	
	check_imapstore_failure=$(cat imapstore.txt | grep -i "not a valid flag" | wc -l)
	check_imapstore_failure=`echo $check_imapstore_failure | tr -d " "`
	
#check flags
        msg_exists=`cat imapstore.txt | grep EXISTS |cut -d ' ' -f2`
        if [ "$msg_tobeflagged" == "*" ];then
            msg_tobeflagged_no=$msg_exists
        else
            singleflag=`echo $msg_tobeflagged |grep ","|wc -l`
     				if [ $singleflag -eq 1 ]
       			then
       				#firstbegin=1
	       			firstend=`echo $msg_tobeflagged  |awk -F "," '{print $1}'`
	       			#let firstpart=firstend-firstbegin
	       			secondbegin=`echo $msg_tobeflagged  |awk -F "," '{print $2}'|awk -F ":" '{print $1}'`
	       			secondend=`echo $msg_tobeflagged  |awk -F "," '{print $2}'|awk -F ":" '{print $2}'`
	       			let secondpart=secondend-secondbegin+1
	       			let msg_tobeflagged_no=secondpart+firstend	
	       		else      		
        	    	msg_tobeflagged_no=$msg_tobeflagged
	        	fi
        fi
        imap_fetch "$imapUser" "1:*" "flags"
        if [ "$stringused" == "Removed" ];then
            check_flags=$(cat imapfetch.txt | grep "FETCH.*FLAGS" | grep -i "$flagname" | wc -l)
            check_flags=`echo $check_flags | tr -d " "`
            if [ "$check_imapstore" == "1" ] && [ "$check_flags" == "0" ]
            then
                prints "IMAP STORE command for $imapUser is successful,$stringused Flag $flagname" "imap_store" "2"
                Result="0"
            else
                    if [ "$check_imapstore_failure" == "1" ]
                    then
                            prints "IMAP STORE command for $imapUser is successful. $flagname is not a valid flag" "imap_store" "2"
                            Result="0"
                    else
                            prints "-ERR IMAP STORE command for $imapUser is unsuccessful.$flagname could not be $stringused" "imap_store" "1"
                            Result="1"
                    fi
            fi
	else
            check_flags=$(cat imapfetch.txt | grep FETCH| grep -i "$flagname" | wc -l)
            check_flags=`echo $check_flags | tr -d " "`
            if [ "$check_imapstore" == "1" ] && [ "$msg_tobeflagged_no" == "$check_flags" ]
            then
                    prints "IMAP STORE command for $imapUser is successful,$stringused Flag $flagname" "imap_store" "2"
                    Result="0"
            else
                    if [ "$check_imapstore_failure" == "1" ]
                    then
                        prints "IMAP STORE command for $imapUser is successful. $flagname is not a valid flag" "imap_store" "2"
                        Result="0"
                    else
                        prints "-ERR IMAP STORE command for $imapUser is unsuccessful.$flagname could not be $stringused" "imap_store" "1"
                        Result="1"
                fi
            fi
        fi
	
	
}
function imap_append(){
	start_time_tc imap_append_tc
		
	imapUser=$1
	foldername=$2
	sizeofmsg=$3
	textentered=$4
	
	imap_select "$imapUser" "$foldername"
	check_exists_folder=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_exists_folder=`echo $check_exists_folder | tr -d " "`
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a append $foldername $sizeofmsg\r\n" >&3
	echo -en "$textentered\n" >&3
	echo -en "a select $foldername\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapappend.txt
	cat imapappend.txt >> debug.log
	check_imapappend_success=$(cat imapappend.txt | grep -i "APPEND completed" | wc -l)
	check_imapappend_success=`echo $check_imapappend_success | tr -d " "`
	
	check_exists_new=$(cat imapappend.txt |grep -i EXISTS |cut -d " " -f2)
	check_exists_new=`echo $check_exists_new | tr -d " "`
	total_msgcount=$(($check_exists_folder+1))
	if [[ "$total_msgcount" == "$check_exists_new" && "$check_imapappend_success" == "1" ]] 
	then
		prints "IMAP APPEND command is successful for $foldername and the total count of msg after append is $total_msgcount" "imap_append" "2"
		Result="0"
	else 
		prints "-ERR IMAP APPEND command is unsuccessful for $foldername and the total count of msg after append is $total_msgcount" "imap_append" "1"
		Result="1"
	fi
}

function imap_expunge(){
	start_time_tc imap_expunge_tc
	imapUser=$1
	imap_select "$imapUser"
	check_exists=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_exists=`echo $check_exists | tr -d " "`
		
	imap_fetch "$imapUser" "1:*" "flags" 
	check_flags=$(cat imapfetch.txt | grep -i FETCH | grep -i \Deleted | wc -l)
	check_flags=`echo $check_flags | tr -d " "`
		
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername\r\n" >&3
	echo -en "a expunge\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapexpunge.txt
	
	imap_select "$imapUser"
	check_exists_new=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_exists_new=`echo $check_exists_new | tr -d " "`
		
	check_imapexpunge=$(cat imapexpunge.txt | grep -i "OK EXPUNGE completed" | wc -l)
	check_imapexpunge=`echo $check_imapexpunge | tr -d " "`
	
	cat imapexpunge.txt >> debug.log
	total_msgleft=$(($check_exists-$check_flags))
	
	if [ "$total_msgleft" == "$check_exists_new" ] 
	then
		prints "IMAP EXPUNGE command for $imapUser is successful" "imap_expunge" "2"
		Result="0"
	else
		prints "-ERR IMAP EXPUNGE command for $imapUser is unsuccessful" "imap_expunge" "1"
		Result="1"
	fi
}
function imap_copy(){
	start_time_tc imap_copy_tc
	imapUser=$1
	msg_tobecopied=$2
	foldername_tobecopied=$3
	foldername_from_copy=$4
	
	imap_select "$imapUser" "$foldername_from_copy"
	check_exists_fromfolder=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_exists_fromfolder=`echo $check_exists_fromfolder | tr -d " "`
		
	imap_select "$imapUser" "$foldername_tobecopied"
	check_exists_tofolder=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_exists_tofolder=`echo $check_exists_tofolder | tr -d " "`
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername_from_copy\r\n" >&3
	echo -en "a list \"\" *\r\n" >&3
	echo -en "a copy 1:$msg_tobecopied $foldername_tobecopied\r\n" >&3
	echo -en "a select $foldername_tobecopied\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapcopy.txt
	
	check_imapcopy_success=$(cat imapcopy.txt | grep -i "COPY completed" | wc -l)
	check_imapcopy_success=`echo $check_imapcopy_success | tr -d " "`
	
	#check_imapcopy_failure=$(cat imapcopy.txt | grep -i "NO COPY failed" | wc -l)
	#check_imapcopy_failure=`echo $check_imapcopy_failure | tr -d " "`
	
	check_exists_new=$(cat imapcopy.txt | grep -i $msg_tobecopied | grep -i EXISTS | cut -d " " -f2 | tail -1)
	check_exists_new=`echo $check_exists_new | tr -d " "`
	
	cat imapcopy.txt >> debug.log
	total_msgcount=$(($check_exists_tofolder+$msg_tobecopied))
	
	if [[ "$total_msgcount" == "$check_exists_new" && "$check_imapcopy_success" == "1" ]] 
	then
		prints "IMAP COPY command from $foldername_from_copy to $foldername_tobecopied for $imapUser is successful" "imap_copy" "2"
		Result="0"
	else 
		prints "-ERR IMAP COPY command from $foldername_from_copy to $foldername_tobecopied for $imapUser is unsuccessful" "imap_copy" "1"
		Result="1"
	fi
		
}
function imap_move(){
	start_time_tc imap_move_tc
	
	imapUser=$1
	msg_tobemoved=$2
	foldername_tobemoved=$3
	foldername_from_move=$4
	
	set_config_keys "/*/imapserv/enableMOVE" "true" 
			
	imap_select "$imapUser" "$foldername_from_move"
	check_exists_fromfolder=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_exists_fromfolder=`echo $check_exists_fromfolder | tr -d " "`
			
	imap_select "$imapUser" "$foldername_tobemoved"
	check_exists_tofolder=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_exists_tofolder=`echo $check_exists_tofolder | tr -d " "`
			
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername_from_move\r\n" >&3
	echo -en "a move 1:$msg_tobemoved $foldername_tobemoved\r\n" >&3
	echo -en "a select $foldername_tobemoved\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapmove.txt
		
	check_imapmove=$(cat imapmove.txt | grep -i "MOVE completed" | wc -l)
	check_imapmove=`echo $check_imapmove | tr -d " "`
		
	check_exists_new=$(cat imapmove.txt | grep -i $msg_tobemoved |grep -i EXISTS |cut -d " " -f2 | tail -1)
	check_exists_new=`echo $check_exists_new | tr -d " "`
			
	imap_select "$imapUser" 
	check_msgleft_fromfolder=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_msgleft_fromfolder=`echo $check_msgleft_fromfolder | tr -d " "`
		
	total_msgcount_tofolder=$(($check_exists_tofolder+$msg_tobemoved))
	total_msgleft_fromfolder=$(($check_exists_fromfolder-$msg_tobemoved))
	
	
	cat imapmove.txt >> debug.log
	if [[ "$total_msgcount_tofolder" == "$check_exists_new" && "$total_msgleft_fromfolder" == "$check_msgleft_fromfolder" ]]
	then 
		prints "IMAP MOVE command for $imapUser $foldername_from_move to $foldername_tobemoved is successful" "imap_move" "2"
		Result="0"
	else
		prints "-ERR IMAP MOVE command for $imapUser $foldername_from_move to $foldername_tobemoved is unsuccessful" "imap_move" "1"
		Result="1"
	fi
	set_config_keys "/*/imapserv/enableMOVE" "false" 
}	
function imap_create(){
	start_time_tc imap_create_tc
	imapUser=$1
	foldername=$2
		
	folderlist=()
	imconfget -fullpath /*/common/defaultFolderList >& folder.txt
	maxcount=$( cat folder.txt | wc -l)
	index=0
	for((i=1;i<=$maxcount;i++))
		do
			line_p="p"
			line=$i$line_p
			check_folder=$(sed -n $line folder.txt)
			folderlist[$index]="$check_folder"
			index=$index+1
		done
	
	index=$(($index+1))
	folderlist[$index]="INBOX"
	
	function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
	}
		
	if [ $(contains "${folderlist[@]}" "$foldername") == "y" ]
	then
		folder_to_create_flag=0
	else
		folder_to_create_flag=1
	fi
	
	if [ "$folder_to_create_flag" == "1" ]
	then
	
		exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
		echo -en "a login $imapUser $imapUser\r\n" >&3
		echo -en "a create $foldername\r\n" >&3
		echo -en "a list \"\" *\r\n" >&3
		echo -en "a logout\r\n" >&3
		
		cat <&3 > imapcreate.txt
		check_imap_create=$(cat imapcreate.txt | grep -i "OK CREATE completed" | wc -l)
		check_imap_create=`echo $check_imap_create | tr -d " "`
		
		imap_list "$imapUser"
		
		check_createfolder=$(cat imaplist.txt | grep -i $foldername | wc -l)	
		check_createfolder=`echo $check_createfolder | tr -d " "`
		
		cat imapcreate.txt >> debug.log
		if [[ "$check_imap_create" == "1" && "$check_createfolder" == "1" ]]
		then
			prints "IMAP CREATE command is successful. Created folder $foldername" "imap_create" "2"
			Result="0"
		else
			prints "-ERR IMAP CREATE command is unsuccessful. Not able to create folder $foldername" "imap_create" "1"
			Result="1" 
		fi
	else
			prints "The specified folder \"$foldername\" already exists; Create command is successful" "imap_create" "2"
			Result="0" 
	fi
	
}
function imap_delete(){
	start_time_tc imap_delete_tc
	imapUser=$1
	foldername=$2
	
	folderlist=()
	imconfget -fullpath /*/common/defaultFolderList >& folder.txt
	maxcount=$( cat folder.txt | wc -l)
	index=0
	for((i=1;i<=$maxcount;i++))
		do
			line_p="p"
			line=$i$line_p
			check_folder=$(sed -n $line folder.txt)
			folderlist[$index]="$check_folder"
			index=$index+1
		done
	
	index=$(($index+1))
	folderlist[$index]="INBOX"
	
	function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
	}
		
	if [ $(contains "${folderlist[@]}" "$foldername") == "y" ]
	then
		folder_to_create_flag=0
	else
		folder_to_create_flag=1
	fi
	
	if [ "$folder_to_create_flag" == "1" ]
	then
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a delete $foldername\r\n" >&3
	echo -en "a list \"\" *\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapdelete.txt
	
	check_imapdelete=$(cat imapdelete.txt | grep -i "OK DELETE completed" | wc -l)
	check_imapdelete=`echo $check_imapdelete | tr -d " "`
	
	imap_list "$imapUser"
	check_deletefolder=$(cat imaplist.txt | grep -i $foldername | wc -l)
	check_deletefolder=`echo $check_deletefolder | tr -d " "`
	
	cat imapdelete.txt >> debug.log
	if [[ "$check_imapdelete" == "1" && "$check_deletefolder" == "0" ]]
	then
		prints "IMAP DELETE command is successful. Able to delete folder $foldername_to_delete" "imap_delete" "2"
		Result="0"
	else
		prints "-ERR IMAP DELETE command is unsuccessful. Not able to delete folder $foldername_to_delete" "imap_delete" "1"
		Result="1"
	fi
	else
		prints "The default folder \"$foldername\" cannot be deleted ; Delete command is successful" "imap_delete" "2"
		Result="0" 
	fi
	
}
function imap_rename(){
	start_time_tc imap_rename_tc
	imapUser=$1
	foldername=$2
	new_foldername=$3
	
	folderlist=()
	imconfget -fullpath /*/common/defaultFolderList >& folder.txt
	maxcount=$( cat folder.txt | wc -l)
	index=0
	for((i=1;i<=$maxcount;i++))
		do
			line_p="p"
			line=$i$line_p
			check_folder=$(sed -n $line folder.txt)
			folderlist[$index]="$check_folder"
			index=$index+1
		done
	
	index=$(($index+1))
	folderlist[$index]="INBOX"
	
	function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
	}
	
	if [ $(contains "${folderlist[@]}" "$foldername") == "y" ]
	then
		folder_to_create_flag=0
	else
		folder_to_create_flag=1
	fi
	if [ $(contains "${folderlist[@]}" "$new_foldername") == "y" ]
	then
		folder_to_create_flag=0
	else
		folder_to_create_flag=1
	fi	
	
	if [ "$folder_to_create_flag" == "0" ]
	then
		prints "The specified mailbox already exists.. Cannot rename" "imap_rename" "2"
		Result="0"
	else	
 
	if [ "$foldername" == "$new_foldername" ]
	then
		prints "The specified mailbox already exists.. Cannot rename" "imap_rename" "2"
		Result="0"
	else
		prints "Renaming the folder" "imap_rename" 
		exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
		echo -en "a login $imapUser $imapUser\r\n" >&3
		echo -en "a list \"\" *\r\n" >&3
		echo -en "a rename $foldername $new_foldername\r\n" >&3
		echo -en "a logout\r\n" >&3
		cat <&3 > imaprename.txt
		
		check_imap_rename=$(cat imaprename.txt | grep -i "OK RENAME completed" | wc -l)
		check_imap_rename=`echo $check_imap_rename | tr -d " "`
		
		imap_list "$imapUser"
		
		check_newfolder=$(cat imaplist.txt | grep -i $new_foldername | wc -l)	
		check_newfolder=`echo $check_newfolder | tr -d " "`
		check_oldfolder=$(cat imaplist.txt | grep -i $foldername | wc -l)	
		check_oldfolder=`echo $check_oldfolder | tr -d " "`
		cat imaprename.txt >> debug.log
		if [[ "$check_imap_rename" == "1" && "$check_newfolder" == "1" ]]
		then
			prints "IMAP RENAME command is successful. Renamed folder $foldername to $new_foldername" "imap_rename" "2"
			Result="0"
		else
			prints "-ERR IMAP RENAME command is unsuccessful. Not able to rename folder $foldername to $new_foldername" "imap_rename" "1"
			Result="1" 
		fi
	fi
	fi
		
}

function imap_examine(){
	start_time_tc imap_examine_tc
	
	imapUser=$1
	foldername=$2
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a examine $foldername\r\n" >&3
	echo -en "a store 1 +flags \Draft\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapexamine.txt
	cat imapexamine.txt >> debug.log
	
	check_imapexamine=$(cat imapexamine.txt | grep -i "EXAMINE completed" | cut -d " " -f3)
	check_imapexamine=`echo $check_imapexamine | tr -d " "`
	
	verify_imapexamine=$(cat imapexamine.txt | grep -i  "NO The mailbox is read-only" | wc -l)
	verify_imapexamine=`echo $verify_imapexamine | tr -d " "`
	
	if [[ "$check_imapexamine" == "[READ-ONLY]" && "$verify_imapexamine" == "1" ]]
	then
		prints "IMAP EXAMINE for $imapUser is successful" "imap_examine" "2"
		Result="0"
	else
		prints "ERROR: IMAP EXAMINE for $user2 is not successful" "imap_examine" "1"
		prints "ERROR: IMAP EXAMINE for $user2 is not successful. Please check Manually." "imap_examine" "1"
		Result="1"
	fi
	
}
function imap_search(){
	start_time_tc imap_search_tc
	
	imapUser=$1
	foldername=$2
	option=$3
	value=$4
		
	if [ "$4" == "" ]
	then
		exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
		echo -en "a login $imapUser $imapUser\r\n" >&3
		echo -en "a select $foldername\r\n" >&3
		echo -en "a search $option\r\n" >&3
		echo -en "a logout\r\n" >&3
		cat <&3 > imapsearch.txt
		cat imapsearch.txt >> debug.log
	else
		exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
		echo -en "a login $imapUser $imapUser\r\n" >&3
		echo -en "a select $foldername\r\n" >&3
		echo -en "a search $option $value\r\n" >&3
		echo -en "a logout\r\n" >&3
		cat <&3 > imapsearch.txt
		cat imapsearch.txt >> debug.log
	fi	
		check_imapsearch=$(cat imapsearch.txt | grep -i "SEARCH completed" | wc -l)
		check_imapsearch=`echo $check_imapsearch | tr -d " "`
		if [ "$check_imapsearch" == "1" ]
		then
			prints "IMAP SEARCH for $imapUser is successful" "imap_search" "2"
			Result="0"
		else
			prints "-ERR IMAP SEARCH for $imapUser is unsuccessful" "imap_search" "1"
			Result="1"
		fi
}
# testcase 28
function imap_logout(){
	start_time_tc imap_logout_tc
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a logout\r\n" >&3
	
	cat <&3 > imaplogout.txt
	cat imaplogout.txt >> debug.log
	check_imaplogout=$(cat imaplogout.txt | grep -i "OK LOGOUT completed" | wc -l)
	check_imaplogout=`echo $check_imaplogout | tr -d " "`
	if [ "$check_imaplogout" == "1" ]
	then
		prints "IMAP Logout is successful" "imap_logout" "2"
		Result="0"
	else
		prints "IMAP Logout is unsuccessful" "imap_logout" "1"
		Result="1"
	fi
	summary "IMAP:TC_IMAP_Logout" $Result
}
function imap_sort() {
	start_time_tc imap_sort_tc
	imapUser=$1
	foldername=$2
	option=$3
	set_config_keys "/*/imapserv/enableSORT" "true" "1"
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername\r\n" >&3 
	echo -en "a uid sort ($option) us-ascii all\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapsort.txt
	cat imapsort.txt >>debug.log
	check_imapsort=$(cat imapsort.txt | grep -i "SORT completed" | wc -l)
	check_imapsort=`echo $check_imapsort | tr -d " "`
	if [ "$check_imapsort" == "1" ]
	then
		prints "IMAP SORT for $imapUser is successful" "imap_search" "2"
		Result="0"
	else
		prints "-ERR IMAP SORT for $imapUser is unsuccessful" "imap_search" "1"
		Result="1"
	fi
}
function imap_capability() {
	start_time_tc imap_capability_tc
	imapUser=$1
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a capability\r\n" >&3
	echo -en "a logout\r\n" >&3
	
	cat <&3 > imapCapablity.log
	cat imapCapablity.log >> debug.log
        check_capability_count1=$(cat imapCapablity.log | awk '{print $4}' | grep 'UIDPLUS' | wc -l)
        check_capability_count2=$(cat imapCapablity.log | awk '{print $4}' | grep 'completed' | wc -l)
	if [[ $check_capability_count1 == 1 && $check_capability_count2 == 3 ]]; then
		prints "IMAP CAPABILITY for $imapUser is successful" "imap_capability" "2"
		Result="0" 
	else 
		prints "-ERR IMAP CAPABILITY for $imapUser is unsuccessful" "imap_capability" "1"
		Result="1"
	fi
	
}
# check imap status command
function imap_status() {
	# record start time
	start_time_tc imap_status_tc
	imapUser=$1
	# login and check status command
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a status inbox (messages recent uidnext UNSEEN)\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapStatus.log
	cat imapSatus.log >> debug.log
	# assert result
	check_status_count=$(cat imapStatus.log | grep 'STATUS completed' | wc -l)
	if [[ $check_status_count == 1 ]] ;then
		prints "IMAP STATUS for $imapUser is successful" "imap_status" "2"
		Result="0"
	else 
		prints "-ERR IMAP STATUS for $imapUser is unsuccessful" "imap_status" "1"
		Result="1"
	fi
}
function imap_thread_operations(){
        set_config_keys "/*/imapserv/enableTHREAD" "true" 1 	
        set_config_keys "/*/mss/ConversationViewEnabled" "true" 1 	
        set_config_keys "/*/mss/currentIndexesVersion" 'CF_TimeIndex 0\nCF_SubjectIndex 0\nCF_FromIndex 0\nCF_SizeIndex 0\nCF_PriorityIndex 0\nCF_AttIndex 0\nCF_ToIndex 0\nCF_CcIndex 0\nCF_RMFlagIndex 0\nCF_UIDIndex 0\nCF_RecentIndex 0\nCF_ConversationIndex 0\nCF_ConversationIndex1 1\nCF_MessageFlagsIndex 1' 1
        imctrl  allhosts  killStart mss 
        sleep 10
        prints "=========================================" "TC_thread_references_utf8_all"
        prints "IMAP THREAD Operations " "TC_thread_references_utf8_all"
        prints "=========================================" "TC_thread_references_utf8_all"
        TC_thread_references_utf8_all
        prints "=============End of Step=================" "TC_thread_references_utf8_all"
        prints "=========================================" "TC_thread_references_utf8_flags"
        prints "IMAP THREAD Operations " "TC_thread_references_utf8_flags"
        prints "=========================================" "TC_thread_references_utf8_flags"
        TC_thread_references_utf8_flags
        prints "=============End of Step=================" "TC_thread_references_utf8_flags"
        prints "=========================================" "TC_thread_references_utf8_keyword"
        prints "IMAP THREAD Operations " "TC_thread_references_utf8_keyword"
        prints "=========================================" "TC_thread_references_utf8_keyword"
        TC_thread_references_utf8_keyword
        prints "=============End of Step=================" "TC_thread_references_utf8_keyword"
        prints "=========================================" "TC_thread_references_utf8_copy"
        prints "IMAP THREAD Operations " "TC_thread_references_utf8_copy"
        prints "=========================================" "TC_thread_references_utf8_copy"
        TC_thread_references_utf8_copy
        prints "=============End of Step=================" "TC_thread_references_utf8_copy"
        prints "=========================================" "TC_thread_references_us_ascii_all"
        prints "IMAP THREAD Operations " "TC_thread_references_us_ascii_all"
        prints "=========================================" "TC_thread_references_utf8_all"
        TC_thread_references_us_ascii_all
        prints "=============End of Step=================" "TC_thread_references_us_ascii_all"
        prints "=========================================" "TC_thread_orderedsubject_utf8_all"
        prints "IMAP THREAD Operations " "TC_thread_orderedsubject_utf8_all"
        prints "=========================================" "TC_thread_orderedsubject_utf8_all"
        TC_thread_orderedsubject_utf8_all
        prints "=============End of Step=================" "TC_thread_orderedsubject_utf8_all"
        prints "=========================================" "TC_thread_orderedsubject_us_ascii_all"
        prints "IMAP THREAD Operations " "TC_thread_orderedsubject_us_ascii_all"
        prints "=========================================" "TC_thread_orderedsubject_utf8_all"
        TC_thread_orderedsubject_us_ascii_all
        prints "=============End of Step=================" "TC_thread_orderedsubject_us_ascii_all"
        prints "=========================================" "TC_thread_references_in_nestedfolder_utf8_all"
        prints "IMAP THREAD Operations " "TC_thread_references_in_nestedfolder_utf8_all"
        prints "=========================================" "TC_thread_references_in_nestedfolder_utf8_all"
        TC_thread_references_in_nestedfolder_utf8_all
        prints "=============End of Step=================" "TC_thread_references_in_nestedfolder_utf8_all"
        set_config_keys "/*/imapserv/enableTHREAD" "false" 1 	
        set_config_keys "/*/mss/ConversationViewEnabled" "false" 1 
        imctrl  allhosts  killStart mss 
        sleep 10
}
function imap_thread(){
	start_time_tc imap_thread_tc
	
	imapUser=$1
	foldername=$2
	option=$3
	value=$4
		
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $imapUser $imapUser\r\n" >&3
	echo -en "a select $foldername\r\n" >&3
	echo -en "a thread $option $value\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapthread.txt
	cat imapthread.txt >> debug.log
	
	check_imapthread=$(cat imapthread.txt | grep -i "THREAD completed" | wc -l)
	check_imapthread=`echo $check_imapthread | tr -d " "`
	if [ "$check_imapthread" == "1" ]
	then
		prints "IMAP THREAD for $imapUser is successful" "imap_thread" "2"
		Result="0"
	else
		prints "-ERR IMAP THREAD for $imapUser is unsuccessful" "imap_thread" "1"
		Result="1"
	fi
}


#folderhare and unshare functions,added begin MX9.5
function shareFolder(){
	mxoshost_port=$1
	userfrom=$2
	userto=$3
	foldername=$4
	
	curl -X PUT -v -H "Content-Type: application/x-www-form-urlencoded"  "http://${mxoshost_port}/mxos/mailbox/v2/${userfrom}@openwave.com/folders/${foldername}/share/${userto}@openwave.com"   &> foldershare.txt
  outcome_det=`grep "200 OK" foldershare.txt |wc -l`
  cat foldershare.txt
  if [ $outcome_det -eq 1 ];then
  	prints "Foldershare for folder:$foldername from $userfrom to $userto is successful" "shareFolder" "2"
		Result_share="0"
	else
		prints "-ERR Foldershare for folder:$foldername from $userfrom to $userto is unsuccessful" "shareFolder" "1"
		Result_share="1"	
  fi
} 


function unshareFolder(){
	mxoshost_port=$1
	userfrom=$2
	userto=$3
	foldername=$4
	
	curl -X DELETE -v -H "Content-Type: application/x-www-form-urlencoded"  "http://${mxoshost_port}/mxos/mailbox/v2/${userfrom}@openwave.com/folders/${foldername}/share/${userto}@openwave.com"   &> foldershare.txt
  outcome_det=`grep "200 OK" foldershare.txt |wc -l`
  if [ $outcome_det -eq 1 ];then
  	prints "UnFoldershare for folder:$foldername from $userfrom to $userto successful" "UnshareFolder" "2"
		Result="0"
	else
		prints "-ERR UnFoldershare for folder:$foldername from $userfrom to $userto is unsuccessful" "UnshareFolder" "1"
		Result="1"	
  fi
}




function TC_thread_references_utf8_all(){
        start_time_tc TC_thread_references_utf8_all_tc
       
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail1=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail2=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 1
        mail3=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 2
        mail4=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail5=$Result
        result=($mail1 $mail2 $mail3 $mail4 $mail5)
        echo ${result[@]} | grep -q 1 
        if [ $? -ne 0 ];then
            imap_thread "$user9" "INBOX" "REFERENCES UTF-8" "all"
            verify_imapthread=$(cat imapthread.txt | grep -i "THREAD" | grep '(1 3) (2 4) (5)' | wc -l)
            verify_imapthread=`echo $verify_imapthread | tr -d " "`
            if [ "$verify_imapthread" == "1" ]
            then
                prints "IMAP THREAD for $user9 is successful" "TC_thread_references_utf8_all" "2"
                Result="0"
            else
                prints "-ERR IMAP THREAD for $user9 is unsuccessful" "TC_thread_references_utf8_all" "1"
                Result="1"
            fi
        else
            prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
            Result="1"
        fi
        summary "IMAP:TC_thread_references_utf8_all" $Result
        immsgdelete_utility "$user9" "-all"
}
# testcase 125
function TC_thread_references_utf8_keyword(){
        start_time_tc TC_thread_references_utf8_keyword_tc
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail1=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 1
        mail2=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail3=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail4=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 4
        mail5=$Result
        result=($mail1 $mail2 $mail3 $mail4 $mail5)
        echo ${result[@]} | grep -q 1
        if [ $? -ne 0 ];then
            imap_store "$user9" "4" "+" "kwtest" "INBOX"
            store_result=$Result
            if [ $store_result -eq 0 ];then            
                imap_thread "$user9" "INBOX" "REFERENCES UTF-8" "keyword kwtest"
                verify_imapthread=$(cat imapthread.txt | grep -i "THREAD" | grep '(1 2) (3) (4)' | wc -l)
                verify_imapthread=`echo $verify_imapthread | tr -d " "`
                if [ "$verify_imapthread" == "1" ]
                then
                    prints "IMAP THREAD for $user9 is successful" "TC_thread_references_utf8_keyword" "2"
                    Result="0"
                else
                    prints "-ERR IMAP THREAD for $user9 is unsuccessful" "TC_thread_references_utf8_keyword" "1"
                    Result="1"
                fi
            else
                prints "-ERR keyword stored unsuccessfully" "imap_store" "1"
                Result="1"
            fi    
        else
            prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
            Result="1"
        fi
        summary "IMAP:TC_thread_references_utf8_keyword" $Result
        immsgdelete_utility "$user9" "-all"
}
# testcase 124
function TC_thread_references_utf8_flags(){
        start_time_tc TC_thread_references_utf8_flags_tc
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail1=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 1
        mail2=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 
        mail3=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 2
        mail4=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 3
        mail5=$Result
        result=($mail1 $mail2 $mail3 $mail4 $mail5)
        echo ${result[@]} | grep -q 1
        if [ $? -ne 0 ];then
            imap_store "$user9" "2,4:5" "+" "\Deleted" "INBOX"
            imap_thread "$user9" "INBOX" "REFERENCES UTF-8" "Deleted"
            verify_imapthread=$(cat imapthread.txt | grep -i "THREAD" | grep '(1 2 4) (5)' | wc -l)
            verify_imapthread=`echo $verify_imapthread | tr -d " "`
            if [ "$verify_imapthread" == "1" ]
            then
                prints "IMAP THREAD for $user9 is successful" "TC_thread_references_utf8_flags" "2"
                Result="0"
            else
                prints "-ERR IMAP THREAD for $user9 is unsuccessful" "TC_thread_references_utf8_flags" "1"
                Result="1"
            fi
        else
            prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
            Result="1"
        fi
        summary "IMAP:TC_thread_references_utf8_flags" $Result
        immsgdelete_utility "$user9" "-all"
}
# testcase 126
function TC_thread_references_utf8_copy(){
        start_time_tc TC_thread_references_utf8_copy_tc
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail1=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 1
        mail2=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 
        mail3=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 2
        mail4=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 3
        mail5=$Result
        result=($mail1 $mail2 $mail3 $mail4 $mail5)
        echo ${result[@]} | grep -q 1
        if [ $? -ne 0 ];then
            imap_copy "$user9" "5" "SentMail" "INBOX"
            copy_result=$Result
	    imap_store "$user9" "5" "+" "\Deleted" "INBOX"
            store_result=$Result
	    imap_expunge "$user9"
            expunge_result=$Result
            result1=($copy_result $store_result $expunge_result)
            echo ${result1[@]} | grep -q 1
            if [ $? -ne 0 ];then            
                imap_thread "$user9" "SentMail" "REFERENCES UTF-8" "all"
                verify_imapthread=$(cat imapthread.txt | grep -i "THREAD" | grep '(1 2 4) (3 5)' | wc -l)
                verify_imapthread=`echo $verify_imapthread | tr -d " "`
                if [ "$verify_imapthread" == "1" ]
                then
                    prints "IMAP THREAD for $user9 is successful" "TC_thread_references_utf8_copy" "2"
                    Result="0"
                else
                    prints "-ERR IMAP THREAD for $user9 is unsuccessful" "TC_thread_references_utf8_copy" "1"
                    Result="1"
                fi
            else
                prints "-ERR keyword stored unsuccessfully" "imap_copy" "1"
                Result="1"
            fi    
        else
            prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
            Result="1"
        fi
        summary "IMAP:TC_thread_references_utf8_copy" $Result
        immsgdelete_utility "$user9" "-all"
}
# testcase 127
function TC_thread_references_us_ascii_all(){
        start_time_tc TC_thread_references_us_ascii_all_tc
       
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail1=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail2=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 1
        mail3=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX" 2
        mail4=$Result
        mail_send_thread $user9 "REFERENCES" "INBOX"
        mail5=$Result
        result=($mail1 $mail2 $mail3 $mail4 $mail5)
        echo ${result[@]} | grep -q 1 
        if [ $? -ne 0 ];then
            imap_thread "$user9" "INBOX" "REFERENCES US-ASCII" "all"
            verify_imapthread=$(cat imapthread.txt | grep -i "THREAD" | grep '(1 3) (2 4) (5)' | wc -l)
            verify_imapthread=`echo $verify_imapthread | tr -d " "`
            if [ "$verify_imapthread" == "1" ]
            then
                prints "IMAP THREAD for $user9 is successful" "TC_thread_references_us_ascii_all" "2"
                Result="0"
            else
                prints "-ERR IMAP THREAD for $user9 is unsuccessful" "TC_thread_references_us_ascii_all" "1"
                Result="1"
            fi
        else
            prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
            Result="1"
        fi
        summary "IMAP:TC_thread_references_us_ascii_all" $Result
        immsgdelete_utility "$user9" "-all"
}
# testcase 128
function TC_thread_orderedsubject_utf8_all(){
        start_time_tc TC_thread_orderedsubject_utf8_all_tc
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX"
        mail1=$Result
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX"
        mail2=$Result
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX" 2
        mail3=$Result
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX" 1
        mail4=$Result
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX" 2
        mail5=$Result
        result=($mail1 $mail2 $mail3 $mail4 $mail5)
        echo ${result[@]} | grep -q 1
        if [ $? -ne 0 ];then
            imap_thread "$user9" "INBOX" "ORDEREDSUBJECT UTF-8" "all"
            verify_imapthread=$(cat imapthread.txt | grep -i "THREAD" | grep '(1 4) (2 3 5)' | wc -l)
            verify_imapthread=`echo $verify_imapthread | tr -d " "`
            if [ "$verify_imapthread" == "1" ]
            then
                prints "IMAP THREAD for $user9 is successful" "TC_thread_orderedsubject_utf8_all" "2"
                Result="0"
            else
                prints "-ERR IMAP THREAD for $user9 is unsuccessful" "TC_thread_orderedsubject_utf8_all" "1"
                Result="1"
            fi
        else
            prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
            Result="1"
        fi
        summary "IMAP:TC_thread_orderedsubject_utf8_all" $Result
        immsgdelete_utility "$user9" "-all"
}
# testcase 129
function TC_thread_orderedsubject_us_ascii_all(){
        start_time_tc TC_thread_orderedsubject_us_ascii_all_tc
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX"
        mail1=$Result
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX"
        mail2=$Result
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX" 2
        mail3=$Result
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX" 1
        mail4=$Result
        mail_send_thread $user9 "ORDEREDSUBJECT" "INBOX" 2
        mail5=$Result
        result=($mail1 $mail2 $mail3 $mail4 $mail5)
        echo ${result[@]} | grep -q 1
        if [ $? -ne 0 ];then
            imap_thread "$user9" "INBOX" "ORDEREDSUBJECT US-ASCII" "all"
            verify_imapthread=$(cat imapthread.txt | grep -i "THREAD" | grep '(1 4) (2 3 5)' | wc -l)
            verify_imapthread=`echo $verify_imapthread | tr -d " "`
            if [ "$verify_imapthread" == "1" ]
            then
                prints "IMAP THREAD for $user9 is successful" "TC_thread_orderedsubject_us_ascii_all" "2"
                Result="0"
            else
                prints "-ERR IMAP THREAD for $user9 is unsuccessful" "TC_thread_orderedsubject_us_ascii_all" "1"
                Result="1"
            fi
        else
            prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
            Result="1"
        fi
        summary "IMAP:TC_thread_orderedsubject_us_ascii_all" $Result
        immsgdelete_utility "$user9" "-all"
}
# testcase 130
function TC_thread_references_in_nestedfolder_utf8_all(){
        start_time_tc TC_thread_references_in_nestedfolder_utf8_all_tc
        folder="Folder1/Folder2"
        mail_send_thread $user9 "REFERENCES" $folder
        mail1=$Result
        mail_send_thread $user9 "REFERENCES" $folder
        mail2=$Result
        mail_send_thread $user9 "REFERENCES" $folder 1
        mail3=$Result
        mail_send_thread $user9 "REFERENCES" $folder 2
        mail4=$Result
        mail_send_thread $user9 "REFERENCES" $folder 4
        mail5=$Result
        result=($mail1 $mail2 $mail3 $mail4 $mail5)
        echo ${result[@]} | grep -q 1
        if [ $? -ne 0 ];then
            imap_thread "$user9" "$folder" "REFERENCES UTF-8" "all"
            verify_imapthread=$(cat imapthread.txt | grep -i "THREAD" | grep '(1 3) (2 4 5)' | wc -l)
            verify_imapthread=`echo $verify_imapthread | tr -d " "`
            if [ "$verify_imapthread" == "1" ]
            then
                prints "IMAP THREAD for $user9 is successful" "TC_thread_references_in_nestedfolder_utf8_all" "2"
                Result="0"
            else
                prints "-ERR IMAP THREAD for $user9 is unsuccessful" "TC_thread_references_in_nestedfolder_utf8_all" "1"
                Result="1"
            fi
        else
            prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
            Result="1"
        fi
        summary "IMAP:TC_thread_references_in_nestedfolder_utf8_all" $Result
        imap_delete "$user9" "$folder"
}
function IMAP_TestScenarios(){
	
	# Function call of TestScenarios for LIST Command
	prints "=========================================" "TC_Imap_list" 
	prints "IMAP_TestScenarios" "TC_Imap_list" 
		
	TC_Imap_list
	prints "=============END OF TC_Imap_list =================" "TC_Imap_list"
	
	# Function call of TestScenarios for EXAMINE Command
	prints "=========================================" "TC_Imap_Examine" 
	prints "IMAP_TestScenarios" "TC_Imap_Examine" 
	
	TC_Imap_Examine
	prints "=============END OF TC_Imap_Examine =================" "TC_Imap_Examine"
	
	# Function call of TestScenarios for Select Command
	prints "=========================================" "TC_Imap_Select_Inbox" 
	prints "IMAP_TestScenarios" "TC_Imap_Select_Inbox" 
	
	# Function call of TestScaenaros for Capability Command
	prints "========================================" "TC_Imap_capability"
	TC_Imap_Capability
	# Function all of TestScenarios for STATUS Command
	prints "=========================================" "TC_Imap_status"
	TC_Imap_Status
		
	TC_Imap_Select_Inbox
	prints "=============END OF TC_Imap_Select_Inbox =================" "TC_Imap_Select_Inbox"
	
	prints "=========================================" "TC_Imap_Select_Trash" 
	prints "IMAP_TestScenarios" "TC_Imap_Select_Trash" 
		
	TC_Imap_Select_Trash
	prints "=============END OF TC_Imap_Select_Trash =================" "TC_Imap_Select_Trash"
	
	prints "=========================================" "TC_Imap_Select_SentMail" 
	prints "IMAP_TestScenarios" "TC_Imap_Select_SentMail" 
		
	TC_Imap_Select_SentMail
	prints "=============END OF TC_Imap_Select_SentMail =================" "TC_Imap_Select_SentMail"	
	
	prints "=========================================" "TC_Imap_Select_Customfolder" 
	prints "IMAP_TestScenarios" "TC_Imap_Select_Customfolder" 
		
	TC_Imap_Select_Customfolder
	prints "=============END OF TC_Imap_Select_Customfolder =================" "TC_Imap_Select_Customfolder"
	
	# Function call of TestScenarios for IDLE Command
	prints "=========================================" "TC_Imap_idle" 
	prints "IMAP_TestScenarios" "TC_Imap_idle" 
	
	TC_Imap_idle
	prints "=============END OF TC_Imap_idle =================" "TC_Imap_idle"
	
	# Function call of TestScenarios for GETQUOTA ROOT Command
	prints "=========================================" "TC_Imap_getquota_root" 
	prints "IMAP_TestScenarios" "TC_Imap_getquota_root" 
	
	TC_Imap_getquota_root
	prints "=============END OF TC_Imap_getquota_root =================" "TC_Imap_getquota_root"
	
	# Function call of TestScenarios for NOOP Command
	prints "=========================================" "TC_Imap_noop" 
	prints "IMAP_TestScenarios" "TC_Imap_noop" 
	
	TC_Imap_noop
	prints "=============END OF TC_Imap_noop =================" "TC_Imap_noop"
	
	# Function call of TestScenarios for CHECK Command
	prints "=========================================" "TC_Imap_check" 
	prints "IMAP_TestScenarios" "TC_Imap_check" 
		
	TC_Imap_check
	prints "=============END OF TC_Imap_check =================" "TC_Imap_check"
	
	# Function call of TestScenarios for CLOSE Command
	prints "=========================================" "TC_Imap_close" 
	prints "IMAP_TestScenarios" "TC_Imap_close" 
	
	TC_Imap_close
	prints "=============END OF TC_Imap_close =================" "TC_Imap_close"
	
	# Function call of TestScenarios for rfc822
	prints "=========================================" "TC_fetch_single_message_rfc822" 
	prints "IMAP_TestScenarios" "TC_fetch_single_message_rfc822" 
		
	TC_fetch_single_message_rfc822
	prints "=============END OF TC_fetch_single_message_rfc822 =================" "TC_fetch_single_message_rfc822" 	
	
	prints "=========================================" "TC_fetch_multiple_message_rfc822" 
	prints "IMAP_TestScenarios" "TC_fetch_multiple_message_rfc822" 
		
	TC_fetch_multiple_message_rfc822
	prints "=============END OF TC_fetch_multiple_message_rfc822 =================" "TC_fetch_multiple_message_rfc822" 	
	
	prints "=========================================" "TC_fetch_range_message_rfc822" 
	prints "IMAP_TestScenarios" "TC_fetch_range_message_rfc822" 
		
	TC_fetch_range_message_rfc822
	prints "=============END OF TC_fetch_range_message_rfc822 =================" "TC_fetch_range_message_rfc822" 	
	
	prints "=========================================" "TC_fetch_all_message_rfc822" 
	prints "IMAP_TestScenarios" "TC_fetch_all_message_rfc822" 
		
	TC_fetch_all_message_rfc822
	prints "=============END OF TC_fetch_all_message_rfc822 =================" "TC_fetch_all_message_rfc822" 
		
	prints "=========================================" "TC_fetch_option1_message_rfc822" 
	prints "IMAP_TestScenarios" "TC_fetch_option1_message_rfc822" 
		
	TC_fetch_option1_message_rfc822
	prints "=============END OF TC_fetch_option1_message_rfc822 =================" "TC_fetch_option1_message_rfc822" 
	
	prints "=========================================" "TC_fetch_option2_message_rfc822" 
	prints "IMAP_TestScenarios" "TC_fetch_option2_message_rfc822" 
		
	TC_fetch_option2_message_rfc822
	prints "=============END OF TC_fetch_option2_message_rfc822 =================" "TC_fetch_option2_message_rfc822" 
		
	#Function call of TestScenarios for body[text]
		
	prints "=========================================" "TC_fetch_single_message_body_text" 
	prints "IMAP_TestScenarios" "TC_fetch_single_message_body_text" 
		
	TC_fetch_single_message_body_text
	prints "=============END OF TC_fetch_single_message_body_text =================" "TC_fetch_single_message_body_text" 
		
	prints "=========================================" "TC_fetch_multiple_message_body_text" 
	prints "IMAP_TestScenarios" "TC_fetch_multiple_message_body_text" 
		
	TC_fetch_multiple_message_body_text
	prints "=============END OF TC_fetch_multiple_message_body_text =================" "TC_fetch_multiple_message_body_text" 
		
	prints "=========================================" "TC_fetch_range_message_body_text" 
	prints "IMAP_TestScenarios" "TC_fetch_range_message_body_text" 
		
	TC_fetch_range_message_body_text
	prints "=============END OF TC_fetch_range_message_body_text =================" "TC_fetch_range_message_body_text" 
		
	prints "=========================================" "TC_fetch_all_message_body_text" 
	prints "IMAP_TestScenarios" "TC_fetch_all_message_body_text" 
		
	TC_fetch_all_message_body_text
	prints "=============END OF TC_fetch_all_message_body_text =================" "TC_fetch_all_message_body_text" 
	
	prints "=========================================" "TC_fetch_option1_message_body_text" 
	prints "IMAP_TestScenarios" "TC_fetch_option1_message_body_text" 
		
	TC_fetch_option1_message_body_text
	prints "=============END OF TC_fetch_option1_message_body_text =================" "TC_fetch_option1_message_body_text" 
	
	prints "=========================================" "TC_fetch_option2_message_body_text" 
	prints "IMAP_TestScenarios" "TC_fetch_option2_message_body_text" 
		
	TC_fetch_option2_message_body_text
	prints "=============END OF TC_fetch_option2_message_body_text =================" "TC_fetch_option2_message_body_text" 
	
	
	#Function call of TestScenarios for body[header]
	prints "=========================================" "TC_fetch_single_message_body_header"
	prints "IMAP_TestScenarios" "TC_fetch_single_message_body_header"
							
	TC_fetch_single_message_body_header
	prints "=============END OF TC_fetch_single_message_body_header=================" "TC_fetch_single_message_body_header"
	prints "=========================================" "TC_fetch_multiple_message_body_header"
	prints "IMAP_TestScenarios" "TC_fetch_multiple_message_body_header"
							
	TC_fetch_multiple_message_body_header
	prints "=============END OF TC_fetch_multiple_message_body_header =================" "TC_fetch_multiple_message_body_header"
	prints "=========================================" "TC_fetch_range_message_body_header"
	prints "IMAP_TestScenarios" "TC_fetch_range_message_body_header"
							
	TC_fetch_range_message_body_header
	prints "=============END OF TC_fetch_range_message_body_header =================" "TC_fetch_range_message_body_header"
	prints "=========================================" "TC_fetch_all_message_body_header"
	prints "IMAP_TestScenarios" "TC_fetch_all_message_body_header"
							
	TC_fetch_all_message_body_header
	prints "=============END OF TC_fetch_all_message_body_header =================" "TC_fetch_all_message_body_header"
	prints "=========================================" "TC_fetch_option1_message_body_header"
	prints "IMAP_TestScenarios" "TC_fetch_option1_message_body_header"
							
	TC_fetch_option1_message_body_header
	prints "=============END OF TC_fetch_option1_message_body_header =================" "TC_fetch_option1_message_body_header"
	prints "=========================================" "TC_fetch_option2_message_body_header"
	prints "IMAP_TestScenarios" "TC_fetch_option2_message_body_header"
							
	TC_fetch_option2_message_body_header
	prints "=============END OF TC_fetch_option2_message_body_header =================" "TC_fetch_option2_message_body_header"
	
	#Function call of TestScenarios for envelope
	prints "=========================================" "TC_fetch_single_message_envelope"
	prints "IMAP_TestScenarios" "TC_fetch_single_message_envelope"
							
	TC_fetch_single_message_envelope
	prints "=============END OF TC_fetch_single_message_envelope=================" "TC_fetch_single_message_envelope"
	prints "=========================================" "TC_fetch_multiple_message_envelope"
	prints "IMAP_TestScenarios" "TC_fetch_multiple_message_envelope"
							
	TC_fetch_multiple_message_envelope 
	prints "=============END OF TC_fetch_multiple_message_envelope =================" "TC_fetch_multiple_message_envelope"
	prints "=========================================" "TC_fetch_range_message_envelope"
	prints "IMAP_TestScenarios" "TC_fetch_range_message_envelope"
							
	TC_fetch_range_message_envelope
	prints "=============END OF TC_fetch_range_message_envelope =================" "TC_fetch_range_message_envelope"
	prints "=========================================" "TC_fetch_all_message_envelope"
	prints "IMAP_TestScenarios" "TC_fetch_all_message_envelope"
							
	TC_fetch_all_message_envelope 
	prints "=============END OF TC_fetch_all_message_envelope =================" "TC_fetch_all_message_envelope"
	prints "=========================================" "TC_fetch_option1_message_envelope"
	prints "IMAP_TestScenarios" "TC_fetch_option1_message_envelope"
							
	TC_fetch_option1_message_envelope
	prints "=============END OF TC_fetch_option1_message_envelope =================" "TC_fetch_option1_message_envelope"
	prints "=========================================" "TC_fetch_option2_message_envelope"
	prints "IMAP_TestScenarios" "TC_fetch_option2_message_envelope"
							
	TC_fetch_option2_message_envelope
	prints "=============END OF TC_fetch_option2_message_envelope =================" "TC_fetch_option2_message_envelope"
	#Function call of TestScenarios for flags
	prints "=========================================" "TC_fetch_single_message_flags"
	prints "IMAP_TestScenarios" "TC_fetch_single_message_flags"
	TC_fetch_single_message_flags
	prints "=============END OF TC_fetch_single_message_flags=================" "TC_fetch_single_message_flags"
	prints "=========================================" "TC_fetch_multiple_message_flags"
	prints "IMAP_TestScenarios" "TC_fetch_multiple_message_flags"
	TC_fetch_multiple_message_flags
	prints "=============END OF TC_fetch_multiple_message_flags=================" "TC_fetch_multiple_message_flags"
	prints "=========================================" "TC_fetch_range_message_flags"
	prints "IMAP_TestScenarios" "TC_fetch_range_message_flags"
	TC_fetch_range_message_flags
	prints "=============END OF TC_fetch_range_message_flags =================" "TC_fetch_range_message_flags"
	prints "=========================================" "TC_fetch_all_message_flags"
	prints "IMAP_TestScenarios" "TC_fetch_all_message_flags"
	TC_fetch_all_message_flags
	prints "=============END OF  TC_fetch_all_message_flags =================" "TC_fetch_all_message_flags"
	prints "=========================================" "TC_fetch_option1_message_flags"
	prints "IMAP_TestScenarios" "TC_fetch_option1_message_flags"
	TC_fetch_option1_message_flags
	prints "=============END OF  TC_fetch_option1_message_flags =================" "TC_fetch_option1_message_flags"
	prints "=========================================" "TC_fetch_option2_message_flags"
	prints "IMAP_TestScenarios" "TC_fetch_option2_message_flags"
	TC_fetch_option2_message_flags
	prints "=============END OF  TC_fetch_option2_message_flags =================" "TC_fetch_option2_message_flags"
	
	
	#Function call of TestScenarios for UID
	prints "=========================================" "TC_fetch_single_message_uid"
	prints "IMAP_TestScenarios" "TC_fetch_single_message_uid"
	TC_fetch_single_message_uid
	prints "=============END OF TC_fetch_single_message_uid=================" "TC_fetch_single_message_uid"
	prints "=========================================" "TC_fetch_multiple_message_uid"
	prints "IMAP_TestScenarios" "TC_fetch_multiple_message_uid"
	TC_fetch_multiple_message_uid
	prints "=============END OF TC_fetch_multiple_message_uid=================" "TC_fetch_multiple_message_uid"
	prints "=========================================" "TC_fetch_range_message_uid"
	prints "IMAP_TestScenarios" "TC_fetch_range_message_uid"
	TC_fetch_range_message_uid
	prints "=============END OF TC_fetch_range_message_uid =================" "TC_fetch_range_message_uid"
	prints "=========================================" "TC_fetch_all_message_uid"
	prints "IMAP_TestScenarios" "TC_fetch_all_message_uid"
	TC_fetch_all_message_uid
	prints "=============END OF  TC_fetch_all_message_uid =================" "TC_fetch_all_message_uid"
	prints "=========================================" "TC_fetch_option1_message_uid"
	prints "IMAP_TestScenarios" "TC_fetch_option1_message_uid"
	TC_fetch_option1_message_uid
	prints "=============END OF  TC_fetch_option1_message_uid =================" "TC_fetch_option1_message_uid"
	prints "=========================================" "TC_fetch_option2_message_uid"
	prints "IMAP_TestScenarios" "TC_fetch_option2_message_uid"
	TC_fetch_option2_message_uid
	prints "=============END OF  TC_fetch_option2_message_uid =================" "TC_fetch_option2_message_uid"
	
	
	#Function call of TestScenarios for FULL
	prints "=========================================" "TC_fetch_single_message_full"
	prints "IMAP_TestScenarios" "TC_fetch_single_message_full"
	TC_fetch_single_message_full
	prints "=============END OF TC_fetch_single_message_full=================" "TC_fetch_single_message_full"
	prints "=========================================" "TC_fetch_multiple_message_full"
	prints "IMAP_TestScenarios" "TC_fetch_multiple_message_full"
	TC_fetch_multiple_message_full
	prints "=============END OF TC_fetch_multiple_message_full=================" "TC_fetch_multiple_message_full"
	prints "=========================================" "TC_fetch_range_message_full"
	prints "IMAP_TestScenarios" "TC_fetch_range_message_full"
	TC_fetch_range_message_full
	prints "=============END OF TC_fetch_range_message_full =================" "TC_fetch_range_message_full"
	prints "=========================================" "TC_fetch_all_message_full"
	prints "IMAP_TestScenarios" "TC_fetch_all_message_full"
	TC_fetch_all_message_full
	prints "=============END OF  TC_fetch_all_message_full =================" "TC_fetch_all_message_full"
	prints "=========================================" "TC_fetch_option1_message_full"
	prints "IMAP_TestScenarios" "TC_fetch_option1_message_full"
	TC_fetch_option1_message_full
	prints "=============END OF  TC_fetch_option1_message_full =================" "TC_fetch_option1_message_full"
	prints "=========================================" "TC_fetch_option2_message_full"
	prints "IMAP_TestScenarios" "TC_fetch_option2_message_full"
	TC_fetch_option2_message_full
	prints "=============END OF  TC_fetch_option2_message_full =================" "TC_fetch_option2_message_full"
	
	
	prints "=========================================" "TC_fetch_firstline_data_empty_body"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_empty_body"
	TC_fetch_firstline_data_empty_body
	prints "=============END OF  TC_fetch_firstline_data_empty_body =================" "TC_fetch_firstline_data_empty_body"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_empty_body"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_empty_body"
	TC_uid_fetch_firstline_data_empty_body
	prints "=============END OF  TC_uid_fetch_firstline_data_empty_body =================" "TC_uid_fetch_firstline_data_empty_body"
	
	prints "=========================================" "TC_fetch_firstline_data_empty_body_with_attachment"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_empty_body_with_attachment"
	TC_fetch_firstline_data_empty_body_with_attachment
	prints "=============END OF  TC_fetch_firstline_data_empty_body_with_attachment =================" "TC_fetch_firstline_data_empty_body_with_attachment"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_empty_body_with_attachment"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_empty_body_with_attachment"
	TC_uid_fetch_firstline_data_empty_body_with_attachment
	prints "=============END OF  TC_uid_fetch_firstline_data_empty_body_with_attachment =================" "TC_uid_fetch_firstline_data_empty_body_with_attachment"
	
	#CTE means: Content-Transer-Encoding:
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit"
	TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit =================" "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit"
	
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit"
	TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit =================" "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit"
	
	
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64"
	prints "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64"
	TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64 =================" "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64"
	prints "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64"
	TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64 =================" "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64"
	
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt"
	TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt =================" "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt"
	TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt =================" "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt"
	
	
	
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit"
	TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit =================" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit"
	TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit =================" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit"
	
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64"
	TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64 =================" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_base64"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_base64"
	TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_base64
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_base64 =================" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_base64"
	
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt"
	TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt =================" "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_qt"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_qt"
	TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_qt
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_qt =================" "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_qt"
	
	
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit"
	TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit =================" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit"
	TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit =================" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit"
	
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64"
	TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64 =================" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64"
	TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64 =================" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64"
	
	
	prints "=========================================" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt"
	prints "IMAP_TestScenarios" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt"
	TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt
	prints "=============END OF  TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt =================" "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt"
	
	prints "=========================================" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt"
	prints "IMAP_TestScenarios" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt"
	TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt
	prints "=============END OF  TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt =================" "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt"
	
	
	prints "=========================================" "TC_fetch_modseq"
	prints "IMAP_TestScenarios" "TC_fetch_modseq"
	TC_fetch_modseq
	prints "=============END OF  TC_fetch_modseq =================" "TC_fetch_modseq"
	
	prints "=========================================" "TC_fetch_modseq_for_upgradded_accounts"
	prints "IMAP_TestScenarios" "TC_fetch_modseq_for_upgradded_accounts"
	TC_fetch_modseq_for_upgradded_accounts
	prints "=============END OF  TC_fetch_modseq_for_upgradded_accounts =================" "TC_fetch_modseq_for_upgradded_accounts"
	
	#Function call of TestScenarios for CREATE command
	prints "=========================================" "TC_create_systemfolder"
	prints "IMAP_TestScenarios" "TC_create_systemfolder"
	TC_create_systemfolder
	prints "=============END OF  TC_create_systemfolder =================" "TC_create_systemfolder"
	prints "=========================================" "TC_create_customfolder"
	prints "IMAP_TestScenarios" "TC_create_customfolder"
	
	TC_create_customfolder
	prints "=============END OF  TC_create_customfolder =================" "TC_create_customfolder"
	
	prints "=========================================" "TC_create_nested_customfolder"
	prints "IMAP_TestScenarios" "TC_create_nested_customfolder"
	
	TC_create_nested_customfolder
	prints "=============END OF  TC_create_nested_customfolder =================" "TC_create_nested_customfolder"
	
	prints "=========================================" "TC_create_nested_systemfolder"
	prints "IMAP_TestScenarios" "TC_create_nested_systemfolder"
	
	TC_create_nested_systemfolder
	prints "=============END OF  TC_create_nested_systemfolder =================" "TC_create_nested_systemfolder"
	
	prints "=========================================" "TC_shareFolder_system"
	prints "IMAP_TestScenarios" "TC_shareFolder_system"
	
	TC_shareFolder_system
	prints "=============END OF  TC_shareFolder_system =================" "TC_shareFolder_system"
	
	prints "=========================================" "TC_shareFolder_custom"
	prints "IMAP_TestScenarios" "TC_shareFolder_custom"
	
	TC_shareFolder_custom
	prints "=============END OF  TC_shareFolder_custom =================" "TC_shareFolder_custom"
	
	#foldersahre doesn't support nested folders currently
	#prints "=========================================" "TC_shareFolder_nested_customfolder"
	#prints "IMAP_TestScenarios" "TC_shareFolder_nested_customfolder"
	
	#TC_shareFolder_nested_customfolder
	#prints "=============END OF  TC_shareFolder_nested_customfolder =================" "TC_shareFolder_nested_customfolder"
	
	#prints "=========================================" "TC_shareFolder_nested_systemfolder"
	#prints "IMAP_TestScenarios" "TC_shareFolder_nested_systemfolder"
	
	#TC_shareFolder_nested_systemfolder
	#prints "=============END OF  TC_shareFolder_nested_systemfolder =================" "TC_shareFolder_nested_systemfolder"
	
	#prints "=========================================" "TC_UnshareFolder_nested_systemfolder"
	#prints "IMAP_TestScenarios" "TC_UnshareFolder_nested_systemfolder"
	
	#TC_UnshareFolder_nested_systemfolder
	#prints "=============END OF  TC_UnshareFolder_nested_systemfolder =================" "TC_UnshareFolder_nested_systemfolder"
	
	#prints "=========================================" "TC_UnshareFolder_nested_customfolder"
	#prints "IMAP_TestScenarios" "TC_UnshareFolder_nested_customfolder"
	
	#TC_UnshareFolder_nested_customfolder
	#prints "=============END OF  TC_UnshareFolder_nested_customfolder =================" "TC_UnshareFolder_nested_customfolder"
	
	prints "=========================================" "TC_UnshareFolder_custom"
	prints "IMAP_TestScenarios" "TC_UnshareFolder_custom"
	
	TC_UnshareFolder_custom
	prints "=============END OF  TC_UnshareFolder_custom =================" "TC_UnshareFolder_custom"
	
	prints "=========================================" "TC_UnshareFolder_system"
	prints "IMAP_TestScenarios" "TC_UnshareFolder_system"
	
	TC_UnshareFolder_system
	prints "=============END OF  TC_UnshareFolder_system =================" "TC_UnshareFolder_system"
	
	#Function call of TestScenarios for DELETE command
	prints "=========================================" "TC_delete_systemfolder"
	prints "IMAP_TestScenarios" "TC_delete_systemfolder"
	TC_delete_systemfolder
	prints "=============END OF  TC_delete_systemfolder =================" "TC_delete_systemfolder"
	
	prints "=========================================" "TC_delete_customfolder"
	prints "IMAP_TestScenarios" "TC_delete_customfolder"
	
	TC_delete_customfolder
	prints "=============END OF  TC_delete_customfolder =================" "TC_delete_customfolder"
	
	prints "=========================================" "TC_delete_nested_customfolder"
	prints "IMAP_TestScenarios" "TC_delete_nested_customfolder"
	
	TC_delete_nested_customfolder
	prints "=============END OF  TC_delete_nested_customfolder =================" "TC_delete_nested_customfolder"
	
	
	prints "=========================================" "TC_delete_nested_systemfolder"
	prints "IMAP_TestScenarios" "TC_delete_nested_systemfolder"
	
	TC_delete_nested_systemfolder
	prints "=============END OF  TC_delete_nested_systemfolder =================" "TC_delete_nested_systemfolder"
	
	#Function call of TestScenarios for COPY command
	
	prints "=========================================" "TC_copy_INBOXto_Trash"
	prints "IMAP_TestScenarios" "TC_copy_INBOXto_Trash"
	
	TC_copy_INBOXto_Trash
	prints "=============END OF  TC_copy_INBOXto_Trash =================" "TC_copy_INBOXto_Trash"
	
	prints "=========================================" "TC_copy_Trashto_SentMail"
	prints "IMAP_TestScenarios" "TC_copy_Trashto_SentMail"
	TC_copy_Trashto_SentMail
	prints "=============END OF  TC_copy_Trashto_SentMail =================" "TC_copy_Trashto_SentMail"
	
	prints "=========================================" "TC_copy_INBOX_customfolder"
	prints "IMAP_TestScenarios" "TC_copy_INBOX_customfolder"
	TC_copy_INBOX_customfolder
	prints "=============END OF  TC_copy_INBOX_customfolder =================" "TC_copy_INBOX_customfolder"
	
	prints "=========================================" "TC_copy_customfolder_otherfolder"
	prints "IMAP_TestScenarios" "TC_copy_customfolder_otherfolder"
	
	TC_copy_customfolder_otherfolder
	prints "=============END OF  TC_copy_customfolder_otherfolder =================" "TC_copy_customfolder_otherfolder"
	
	#Function call of TestScenarios for APPEND command
	
	prints "=========================================" "TC_append_systemfolder"
	prints "IMAP_TestScenarios" "TC_append_systemfolder"
	
	TC_append_systemfolder
	prints "=============END OF  TC_append_systemfolder =================" "TC_append_systemfolder"
	
	prints "=========================================" "TC_append_customfolder"
	prints "IMAP_TestScenarios" "TC_append_customfolder"
	
	TC_append_customfolder
	prints "=============END OF  TC_append_customfolder =================" "TC_append_customfolder"
	
	#Function call of TestScenarios for RENAME command
	
	prints "=========================================" "TC_rename_systemfolder_customfolder_Trash"
	prints "IMAP_TestScenarios" "TC_rename_systemfolder_customfolder_Trash"
	
	TC_rename_systemfolder_customfolder_Trash
	prints "=============END OF  TC_rename_systemfolder_customfolder_Trash =================" "TC_rename_systemfolder_customfolder_Trash"
	
	prints "=========================================" "TC_rename_systemfolder_customfolder_Inbox"
	prints "IMAP_TestScenarios" "TC_rename_systemfolder_customfolder_Inbox"
	
	TC_rename_systemfolder_customfolder_Inbox
	prints "=============END OF  TC_rename_systemfolder_customfolder_Inbox =================" "TC_rename_systemfolder_customfolder_Inbox"
	
	prints "=========================================" "TC_rename_systemfolder_customfolder_SentMail"
	prints "IMAP_TestScenarios" "TC_rename_systemfolder_customfolder_SentMail"
	
	TC_rename_systemfolder_customfolder_SentMail
	prints "=============END OF  TC_rename_systemfolder_customfolder_SentMail =================" "TC_rename_systemfolder_customfolder_SentMail"
		
	
	prints "=========================================" "TC_rename_customfolder_systemfolder_SentMail"
	prints "IMAP_TestScenarios" "TC_rename_customfolder_systemfolder_SentMail"
	
	TC_rename_customfolder_systemfolder_SentMail
	prints "=============END OF  TC_rename_customfolder_systemfolder_SentMail =================" "TC_rename_customfolder_systemfolder_SentMail"
	prints "=========================================" "TC_rename_customfolder_systemfolder_Inbox"
	prints "IMAP_TestScenarios" "TC_rename_customfolder_systemfolder_Inbox"
	
	TC_rename_customfolder_systemfolder_Inbox
	prints "=============END OF  TC_rename_customfolder_systemfolder_Inbox =================" "TC_rename_customfolder_systemfolder_Inbox"
	
	prints "=========================================" "TC_rename_customfolder_systemfolder_Trash"
	prints "IMAP_TestScenarios" "TC_rename_customfolder_systemfolder_Trash"
	
	TC_rename_customfolder_systemfolder_Trash
	prints "=============END OF  TC_rename_customfolder_systemfolder_Trash =================" "TC_rename_customfolder_systemfolder_Trash"
	
	prints "=========================================" "TC_rename_customfolder_newfolder"
	prints "IMAP_TestScenarios" "TC_rename_customfolder_newfolder"	
	
	TC_rename_customfolder_newfolder
	prints "=============END OF  TC_rename_customfolder_newfolder =================" "TC_rename_customfolder_newfolder"
	
	prints "=========================================" "TC_rename_samefoldername"
	prints "IMAP_TestScenarios" "TC_rename_samefoldername"	
	
	TC_rename_samefoldername
	prints "=============END OF  TC_rename_samefoldername =================" "TC_rename_samefoldername"
	
	#Function call of TestScenarios for SEARCH command
	prints "=========================================" "TC_search_all"
	prints "IMAP_TestScenarios" "TC_search_all"
	
	TC_search_all
	prints "=============END OF  TC_search_all =================" "TC_search_all"
	
	prints "=========================================" "TC_search_smaller"
	prints "IMAP_TestScenarios" "TC_search_smaller"
	
	TC_search_smaller
	prints "=============END OF  TC_search_smaller =================" "TC_search_smaller"
	
	prints "=========================================" "TC_search_larger"
	prints "IMAP_TestScenarios" "TC_search_larger"
	
	TC_search_larger
	prints "=============END OF  TC_search_larger =================" "TC_search_larger"
	
	prints "=========================================" "TC_search_From"
	prints "IMAP_TestScenarios" "TC_search_From"
	
	TC_search_From
	prints "=============END OF  TC_search_From =================" "TC_search_From"
	
	prints "=========================================" "TC_search_OR"
	prints "IMAP_TestScenarios" "TC_search_OR"
	 
	TC_search_OR
	prints "=============END OF  TC_search_OR =================" "TC_search_OR"
	
	#Function call of TestScenarios for MOVE command
	prints "=========================================" "TC_move_INBOXto_SentMail"
	prints "IMAP_TestScenarios" "TC_move_INBOXto_SentMail"
	
	TC_move_INBOXto_SentMail
	prints "=============END OF  TC_move_INBOXto_SentMail =================" "TC_move_INBOXto_SentMail"
	
	prints "=========================================" "TC_move_Trashto_Customfolder"
	prints "IMAP_TestScenarios" "TC_move_Trashto_Customfolder"
	
	TC_move_Trashto_Customfolder
	prints "=============END OF  TC_move_Trashto_Customfolder =================" "TC_move_Trashto_Customfolder"
	
	prints "=========================================" "TC_move_customfolder_otherfolder"
	prints "IMAP_TestScenarios" "TC_move_customfolder_otherfolder"
	
	TC_move_customfolder_otherfolder
	prints "=============END OF  TC_move_customfolder_otherfolder =================" "TC_move_customfolder_otherfolder"
	
	
	#Function call of TestScenarios for STORE command
	prints "=========================================" "TC_store_addflag"
	prints "IMAP_TestScenarios" "TC_store_addflag"
	
	TC_store_addflag
	prints "=============END OF  TC_store_addflag =================" "TC_store_addflag"
	
	prints "=========================================" "TC_store_removeflag"
	prints "IMAP_TestScenarios" "TC_store_removeflag"
	
	TC_store_removeflag
	prints "=============END OF  TC_store_removeflag =================" "TC_store_removeflag"
	
	prints "=========================================" "TC_store_add_invalidflag"
	prints "IMAP_TestScenarios" "TC_store_add_invalidflag"
	
	TC_store_add_invalidflag
	prints "=============END OF  TC_store_add_invalidflag =================" "TC_store_add_invalidflag"
	
  prints "=========================================" "TC_store_addkeywords"
  prints "IMAP_TestScenarios" "TC_store_addkeywords"
  TC_store_addkeywords
  prints "=============END OF  TC_store_addkeywords =================" "TC_store_addkeywords"
  prints "=========================================" "TC_store_removekeywords"
  prints "IMAP_TestScenarios" "TC_store_removekeywords"
  TC_store_removekeywords
  prints "=============END OF  TC_store_removekeywords =================" "TC_store_removekeywords"
	#Function call of TestScenarios for SORT command
	prints "=========================================" "TC_sort_from"
	prints "IMAP_TestScenarios" "TC_sort_from"
	
	TC_sort_from
	prints "=============END OF  TC_sort_from =================" "TC_sort_from"
	
	prints "=========================================" "TC_sort_to"
	prints "IMAP_TestScenarios" "TC_sort_to"
	
	TC_sort_to
	prints "=============END OF  TC_sort_to =================" "TC_sort_to"
		
	prints "=========================================" "TC_sort_subject"
	prints "IMAP_TestScenarios" "TC_sort_subject"
	
	TC_sort_subject
	prints "=============END OF  TC_sort_subject =================" "TC_sort_subject"
	
	prints "=========================================" "TC_sort_size"
	prints "IMAP_TestScenarios" "TC_sort_size"
	
	TC_sort_size
	prints "=============END OF  TC_sort_size =================" "TC_sort_size"
}
# testcase 29
function TC_Imap_list(){
	start_time_tc TC_Imap_list_tc
	
	imap_list "$user3"   
	summary "IMAP:TC_Imap_list" $Result
}
#testcase 32
function TC_Imap_Status(){
	start_time_tc imap_status_tc
	imap_status "$user1"
	summary "IMAP:TC_Imap_Status" $Result
}
# testcase 31
function TC_Imap_Capability(){
	start_time_tc imap_capability_tc
	imap_capability "$user1"
	summary "IMAP:TC_Imap_Capability" $Result
}
# testcase 30
function TC_Imap_Examine(){
	start_time_tc TC_Imap_Examine_tc
	
	imap_examine "$user2" "INBOX"
	summary "IMAP:TC_Imap_Examine" $Result
}
#testcase 33
function TC_Imap_Select_Inbox(){
	start_time_tc TC_Imap_Select_Inbox_tc
	
	imap_select "$user3"  
	summary "IMAP:TC_Imap_Select_Inbox" $Result
}
#testcase 34
function TC_Imap_Select_Trash(){
	start_time_tc TC_Imap_Select_Trash_tc
	
	imap_select "$user3" "Trash"	
	summary "IMAP:TC_Imap_Select_Trash" $Result
}
#testcase 35
function TC_Imap_Select_SentMail(){
	start_time_tc TC_Imap_Select_SentMail_tc
	
	imap_select "$user3" "SentMail"	
	summary "IMAP:TC_Imap_Select_SentMail" $Result
}
#testcase 36
function TC_Imap_Select_Customfolder(){
	start_time_tc TC_Imap_Select_Customfolder_tc
	
	imap_create "$user3" "Folder1"
	imap_select "$user3" "Folder1"	
	summary "IMAP:TC_Imap_Select_Customfolder" $Result
}
#testcase 37
function TC_Imap_idle() {
	start_time_tc TC_Imap_idle_tc
	
	set_config_keys "/*/imapserv/enableIdle" "true" 
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user2 $user2\r\n" >&3
	echo -en "a list \"\" *\r\n" >&3
	echo -en "a select INBOX\r\n" >&3				
	echo -en "a idle\r\n" >&3
	echo -en "DONE\r\n" >&3
	echo -en "a logout\r\n" >&3
	
	cat <&3 &>> imapidle.txt
	cat imapidle.txt >>debug.log
	
	check_idle=$(cat imapidle.txt | grep -i "+ idling" |wc -l)
	check_idle=`echo $check_idle | tr -d " "`
	
	if [ "$check_idle" == "1" ] 
	then
		prints "IMAP IDLE for $user2 is successful" "TC_Imap_idle" "2"
		Result="0"
	else
		prints "ERROR: IMAP IDLE for $user2 is not successful" "TC_Imap_idle" "1"
		prints "ERROR: IMAP IDLE for $user2 is not successful. Please check Manually." "TC_Imap_idle" "1"
		Result="1"
	fi
	
	summary "IMAP:TC_Imap_idle" $Result
	set_config_keys "/*/imapserv/enableIdle" "false" 	
}
#testcase 38
function TC_Imap_getquota_root() {
	start_time_tc TC_Imap_getquota_root_tc
	
	set_cos "$user8" "mailquotamaxmsgs" "100"
	set_cos "$user8" "mailquotatotkb" "10000"
	set_cos "$user8" "mailquotamaxmsgkb" "1000"
	
	mail_send "$user8" "small" "1" 
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user8 $user8\r\n" >&3
	echo -en "a list \"\" *\r\n" >&3
	echo -en "a select INBOX\r\n" >&3				
	echo -en "a getquotaroot INBOX\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > root.txt
	cat  root.txt >>debug.log
	
	check_getquotaroot=$(cat root.txt | grep "QUOTA \"\" " | cut -d "(" -f2 | cut -d ")" -f1 | grep "MESSAGE" | wc -l)
	check_getquotaroot=`echo $check_getquotaroot | tr -d " "`
	
	if [ "$check_getquotaroot" == "1" ]
	then
		prints "IMAP get quota root for INBOX is sucessful" "TC_Imap_getquota_root" "2"
		Result="0"
	else
		prints "ERROR:IMAP get quota root for INBOX is not successful" "TC_Imap_getquota_root" "1"
		prints "ERROR: Please check Manually." "TC_Imap_getquota_root" "1"
		Result="1"
	fi
	
	summary "IMAP:TC_Imap_getquota_root" $Result 
	immsgdelete_utility "$user8" "-all"
}
#testcase 39
function TC_Imap_noop(){
	start_time_tc TC_Imap_noop_tc
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a NOOP\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapnoop1.txt
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user2 $user2\r\n" >&3
	echo -en "a NOOP\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapnoop2.txt
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user2 $user2\r\n" >&3
	echo -en "a select INBOX\r\n" >&3
	echo -en "a NOOP\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapnoop3.txt
	
	cat imapnoop1.txt imapnoop2.txt imapnoop3.txt >> debug.log
	
	check_imapnoop1=$(cat imapnoop1.txt | grep -i "OK NOOP completed" |wc -l)
	check_imapnoop1=`echo $check_imapnoop1 | tr -d " "`
	
	check_imapnoop2=$(cat imapnoop2.txt | grep -i "OK NOOP completed" |wc -l)
	check_imapnoop2=`echo $check_imapnoop2 | tr -d " "`
	
	check_imapnoop3=$(cat imapnoop3.txt | grep -i "OK NOOP completed" |wc -l)
	check_imapnoop3=`echo $check_imapnoop3 | tr -d " "`
	
	if [[ "$check_imapnoop1" == "1" && "$check_imapnoop2" == "1" && "$check_imapnoop3" == "1" ]]
	then
		prints "IMAP NOOP for $user2 is successful" "TC_Imap_noop" "2"
		Result="0"
	else
		prints "ERROR: IMAP NOOP for $user2 is not successful" "TC_Imap_noop" "1"
		prints "ERROR: IMAP NOOP for $user2 is not successful. Please check Manually." "TC_Imap_noop" "1"
		Result="1"
	fi
	summary "IMAP:TC_Imap_noop" $Result 
	
}
#testcase 40
function TC_Imap_check(){
	start_time_tc TC_Imap_check_tc
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a check\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapcheck1.txt
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user2 $user2\r\n" >&3
	echo -en "a check\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapcheck2.txt
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user2 $user2\r\n" >&3
	echo -en "a select INBOX\r\n" >&3
	echo -en "a check\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapcheck3.txt
	
	cat imapcheck1.txt imapcheck2.txt imapcheck3.txt >> debug.log
	
	check_imapcheck1=$(cat imapcheck1.txt | grep -i "BAD Unrecognized command" |wc -l)
	check_imapcheck1=`echo $check_imapcheck1 | tr -d " "`
	
	check_imapcheck2=$(cat imapcheck2.txt | grep -i "BAD Unrecognized command" |wc -l)
	check_imapcheck2=`echo $check_imapcheck2 | tr -d " "`
	
	check_imapcheck3=$(cat imapcheck3.txt | grep -i "OK CHECK completed" |wc -l)
	check_imapcheck3=`echo $check_imapcheck3 | tr -d " "`
	
	if [[ "$check_imapcheck1" == "1" && "$check_imapcheck2" == "1" && "$check_imapcheck3" == "1" ]]
	then
		prints "IMAP CHECK for $user2 is successful" "TC_Imap_check" "2"
		Result="0"
	else
		prints "ERROR: IMAP CHECK for $user2 is not successful" "TC_Imap_check" "1"
		prints "ERROR: IMAP CHECK for $user2 is not successful. Please check Manually." "TC_Imap_check" "1"
		Result="1"
	fi
	summary "IMAP:TC_Imap_check" $Result
	
}
#testcase 41
function TC_Imap_close(){
	start_time_tc TC_Imap_close_tc
	
	mail_send "$user10" "small" "2" 
	imap_select "$user10" "INBOX"
	
	check_exists=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2)
	check_exists=`echo $check_exists | tr -d " "`
	
	exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
	echo -en "a login $user10 $user10\r\n" >&3
	echo -en "a select INBOX\r\n" >&3
	echo -en "a store 2:2 +flags (\Deleted)\r\n" >&3
	echo -en "a examine INBOX\r\n" >&3
	echo -en "a select INBOX\r\n" >&3
	echo -en "a close\r\n" >&3
	echo -en "a select INBOX\r\n" >&3
	echo -en "a logout\r\n" >&3
	cat <&3 > imapclose.txt
	cat imapclose.txt >> debug.log
	
	check_imapclose=$(cat imapclose.txt | grep -i "OK CLOSE completed" |wc -l)
	check_imapclose=`echo $check_imapclose | tr -d " "`
	
	check_exists_new=$(cat imapclose.txt |grep -i EXISTS | cut -d " " -f2 | tail -1)
	check_exists_new=`echo $check_exists_new | tr -d " "`
	
	total_count=$(($check_exists-1))
	if [[ "$check_imapclose" == "1" && "$total_count" == "$check_exists_new" ]]
	then
		prints "IMAP CLOSE for $user10 is successful" "TC_Imap_close" "2"
		Result="0"
	else
		prints "ERROR: IMAP CLOSE for $user10 is not successful" "TC_Imap_close" "1"
		prints "ERROR: IMAP CLOSE for $user10 is not successful. Please check Manually." "TC_Imap_close" "1"
		Result="1"
	fi
	summary "IMAP:TC_Imap_close" $Result
}
#Mx versions check test cases ,testcase 2-10
function MXVERSION() {
start_time_tc
								prints "Checking version of all servers for MX" "MXVERSION"
							    								
								msg_msg_ver2=$(imdbcontrol -version | grep -i version | cut -d " " -f2)
								msg_msg_ver3=$(imdbcontrol -version | grep -i version | cut -d " " -f3)
								
								msg_msg_ver="$msg_msg_ver2 $msg_msg_ver3"
										
								msg_msg_ver1=$(imconfget -localconfig InterMailVersion | grep "$msg_msg_ver" | wc -l)							
								 if [ $msg_msg_ver1 == "1" ]
								then
									prints "Version of the MX is : $msg_msg_ver2 $msg_msg_ver3 " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									
									prints "ERROR: We are not able to find MX version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Veriosn of MX" $Result
								start_time_tc
								mss=$($INTERMAIL/lib/mss -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
								 if [ $mss == "1" ]
								then
									prints "Version of the mss is : $msg_msg_ver2 $msg_msg_ver3   " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									
									prints "ERROR: We are not able to find mss version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of mss" $Result
								start_time_tc
								mta=$($INTERMAIL/lib/mta -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
								 if [ $mta == "1" ]
								then
									prints "Verions of the mta : $msg_msg_ver2 $msg_msg_ver3 " "MXVERSION" "2"
									Result="0"
									#echo 
								else
								 
									prints "ERROR: We are not able to find mta version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of mta" $Result
								start_time_tc
								pop=$($INTERMAIL/lib/popserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
								 if [ $pop == "1" ]
								then
									prints "Verions of the pop : $msg_msg_ver2 $msg_msg_ver3 " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									
									prints "ERROR: We are not able to find pop version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of pop" $Result
								start_time_tc
								imap=$($INTERMAIL/lib/imapserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
								 if [ $imap == "1" ]
								then
									prints "Verions of the imap : $msg_msg_ver2 $msg_msg_ver3  " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									
									prints "ERROR: We are not able to find imap version" "MXVERSION" "1"
									echo
									prints "ERROR: Please check Manually" "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of imap" $Result
								start_time_tc
								ext=$($INTERMAIL/lib/imextserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
								 if [ $ext == "1" ]
								then
 
									prints "Verions of the ext is : $msg_msg_ver2 $msg_msg_ver3  " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									
									prints "ERROR: We are not able to find extension server version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of extension" $Result
								start_time_tc
								queu=$($INTERMAIL/lib/imqueueserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
								 if [ $queu == "1" ]
								then
									prints "Verions of the queu server is : $msg_msg_ver2 $msg_msg_ver3  " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									
									prints "ERROR: We are not able to find queue server version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of queuserver" $Result
								start_time_tc
								dir1=$(imconfget oPWVDirVersion)
								dir=$($INTERMAIL/lib/imdirserv -version | grep "$dir1" | wc -l)
								 if [ $dir == "1" ]
								then
									prints "Verions of the dirserver is :$dir1 " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									
									prints "ERROR: We are not able to find dirserver version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of dirserver" $Result
								start_time_tc
								dircache1=$(imconfget oPWVDirVersion)
								dircache=$($INTERMAIL/lib/imdircacheserv -version | grep "$dircache1" | wc -l)
								if [ $dircache == "1" ]
								then
									prints "Verions of the dircacheserv is :$dircache1 " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									prints "ERROR: We are not able to find dircacheserv version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of dircacheserv" $Result
	
								start_time_tc
								gre=$($INTERMAIL/lib/immgrserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
								 if [ $gre == "1" ]
								then
									prints "Verions of the greserver is : $msg_msg_ver2 $msg_msg_ver3  " "MXVERSION" "2"
									Result="0"
									#echo 
								else
									
									prints "ERROR: We are not able to find MX version" "MXVERSION" "1"
									#echo
									prints "ERROR: Please check Manually." "MXVERSION" "1"
									Result="1"
								fi
								summary "Version of mgrserver" $Result
								start_time_tc
								confserv=$($INTERMAIL/lib/imconfserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
								if [ $confserv == "1" ]
								then
											prints "Verions of the confserv : $msg_msg_ver2 $msg_msg_ver3 " "MXVERSION" "2"
											Result="0"
								else
											prints "ERROR: We are not able to find confserv version" "MXVERSION" "1"
											#echo
											prints "ERROR: Please check Manually." "MXVERSION" "1"
											Result="1"
								fi
								summary "Version of confserv" $Result
}
 
#Special delete fucntions
#testcase 183
function special_delete_config_keys_defaultexpiry() {
	start_time_tc special_delete_config_keys_defaultexpiry_tc
		
	key_present=$(cat $INTERMAIL/config/config.db | grep -i "/*/mss/enableDefaultExpirySpecialDelete" | wc -l)
	key_present=`echo $key_present | tr -d " "`
	if [ "$key_present" == "1" ]
	then
		key_present_flag=0
	else
		key_present_flag=1
	fi
	
	if [ "$key_present_flag" == "0" ]
	then
		key_value=$(cat $INTERMAIL/config/config.db | grep -i "/*/mss/enableDefaultExpirySpecialDelete" | cut -d "[" -f2 | cut -d "]" -f1 | head -1)	
		key_value=`echo $key_value | tr -d " "`
		if [ "$key_value" == "true" ] 
		then
			prints "/*/mss/enableDefaultExpirySpecialDelete is set as true" "special_delete_config_keys_defaultexpiry" "2"
			Result="0"
		else
			prints "/*/mss/enableDefaultExpirySpecialDelete is set as false" "special_delete_config_keys_defaultexpiry" "2"
			Result="0"
		fi
	else
		prints "ERROR :/*/mss/enableDefaultExpirySpecialDelete not present. Please check manually." "special_delete_config_keys_defaultexpiry" "1"
		Result="1"
	fi
	summary "SPECIAL DELETE: special_delete_config_keys_defaultexpiry" $Result 				
														
}
#testcase 184
function special_delete_config_keys_mss() {
	start_time_tc special_delete_config_keys_mss_tc
		
	key_present=$(cat $INTERMAIL/config/config.db | grep -i "/*/mss/enableSpecialDelete" | wc -l)
	key_present=`echo $key_present | tr -d " "`
	if [ "$key_present" -ge "1" ]
	then
		key_present_flag=0
	else
		key_present_flag=1
	fi
	
	if [ "$key_present_flag" == "0" ]
	then
		key_value=$(cat $INTERMAIL/config/config.db | grep -i "/*/mss/enableSpecialDelete" | cut -d "[" -f2 | cut -d "]" -f1 | head -1)	
		key_value=`echo $key_value | tr -d " "`
		if [ "$key_value" == "true" ] 
		then
			prints "/*/mss/enableSpecialDelete is set as true" "special_delete_config_keys_mss" "2"
			Result="0"
		else
			prints "/*/mss/enableSpecialDelete is set as false" "special_delete_config_keys_mss" "2"
			Result="0"
		fi
	else
		prints "ERROR :/*/mss/enableSpecialDelete is not present. Please check manually." "special_delete_config_keys_mss" "1"
		Result="1"
	fi
	summary "SPECIAL DELETE:special_delete_config_keys_mss" $Result 				
														
}
#testcase 185
function special_delete_config_keys_imap() {
	start_time_tc special_delete_config_keys_imap_tc
		
	key_present=$(cat $INTERMAIL/config/config.db | grep -i "/*/imapserv/enableSpecialDelete" | wc -l)
	key_present=`echo $key_present | tr -d " "`
	if [ "$key_present" -ge "1" ]
	then
		key_present_flag=0
	else
		key_present_flag=1
	fi
	
	if [ "$key_present_flag" == "0" ]
	then
		key_value=$(cat $INTERMAIL/config/config.db | grep -i "/*/imapserv/enableSpecialDelete" | cut -d "[" -f2 | cut -d "]" -f1 | head -1)	
		key_value=`echo $key_value | tr -d " "`
		if [ "$key_value" == "true" ] 
		then
			prints "/*/imapserv/enableSpecialDelete is set as true" "special_delete_config_keys_imap" "2"
			Result="0"
		else
			prints "/*/imapserv/enableSpecialDelete is set as false" "special_delete_config_keys_imap" "2"
			Result="0"
		fi
	else
		prints "ERROR :/*/imapserv/enableSpecialDelete is not present. Please check manually." "special_delete_config_keys_imap" "1"
		Result="1"
	fi
	summary "SPECIAL DELETE: special_delete_config_keys_imap" $Result 				
														
}
# testcase 186
function special_delete_config_keys_pop() {
	start_time_tc special_delete_config_keys_pop_tc
		
	
	key_present=$(cat $INTERMAIL/config/config.db | grep -i "/*/popserv/enableSpecialDelete" | wc -l)
	key_present=`echo $key_present | tr -d " "`
	if [ "$key_present" -ge "1" ]
	then
		key_present_flag=0
	else
		key_present_flag=1
	fi
	
	if [ "$key_present_flag" == "0" ]
	then
		key_value=$(cat $INTERMAIL/config/config.db | grep -i "/*/popserv/enableSpecialDelete" | cut -d "[" -f2 | cut -d "]" -f1 | head -1)	
		key_value=`echo $key_value | tr -d " "`
		if [ "$key_value" == "true" ] 
		then
			prints "/*/popserv/enableSpecialDelete is set as true " "special_delete_config_keys_pop" "2"
			Result="0"
		else
			prints "/*/popserv/enableSpecialDelete is set as false " "special_delete_config_keys_pop" "2"
			Result="0"
		fi
	else
		prints "ERROR :/*/popserv/enableSpecialDelete is not present. Please check manually. " "special_delete_config_keys_pop" "1"
		Result="1"
	fi
	
	summary "SPECIAL DELETE:special_delete_config_keys_pop" $Result 				
													
}
function special_delete_case_pop() {
	start_time_tc special_delete_case_pop_tc
	
	user_name=$1	
	set_config_keys "/*/mss/enableSpecialDelete" "true" "1"
	set_config_keys "/*/popserv/enableSpecialDelete" "true" "1"
		
	mail_send "$user_name" "small" "2"
	
	exec 3<>/dev/tcp/$POPHost/$POPPort
	echo -en "user $user_name\r\n" >&3
	echo -en "pass $user_name\r\n" >&3
	echo -en "list\r\n" >&3
	echo -en "dele 1\r\n" >&3
	echo -en "list\r\n" >&3
	echo -en "quit\r\n" >&3
	cat <&3 > special_delete.txt
	cat special_delete.txt >> debug.log	 
	
	imap_select "$user_name"
	check_msgs_imap=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2 )
	check_msgs_imap=`echo $check_msgs_imap | tr -d " "`
	
	imboxstats_fn "$user_name"
	msg_exists_new=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new=`echo $msg_exists_new | tr -d " "`
		
	if [ "$msg_exists_new" == "$check_msgs_imap" ]
	then								
		prints "Special delete for POP is working fine" "special_delete_case_pop" "2"
		Result="0"
	else	
		prints "ERROR:Special delete for POP is not working fine. Please check manually." "special_delete_case_pop" "1"
		Result="1"
	fi
	set_config_keys "/*/popserv/enableSpecialDelete" "false" "1"
}
function special_delete_case_imap() {
	
	start_time_tc special_delete_case_imap_tc
	
	user_name=$1	
	set_config_keys "/*/mss/enableSpecialDelete" "true" "1"
	set_config_keys "/*/imapserv/enableSpecialDelete" "true" "1"
	mail_send "$user_name" "small" "2"
	
	imap_store "$user_name" "1" "+" "\Deleted" "INBOX"
	imap_expunge "$user_name"
	imap_select "$user_name"
	check_msgs_imap=$(cat imapselect.txt | grep -i EXISTS | cut -d " " -f2 )
	check_msgs_imap=`echo $check_msgs_imap | tr -d " "`
		
	pop_list "$user_name"
	check_msgs_pop=$(cat poplist.txt | grep -i "messages" | cut -d " " -f2)
	check_msgs_pop=`echo $check_msgs_pop | tr -d " "`
	
	imboxstats_fn "$user_name"
	msg_exists_new=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new=`echo $msg_exists_new | tr -d " "`
	
	if [ "$msg_exists_new" == "$check_msgs_pop" ]
	then								
		prints "Special delete for IMAP is working fine" "special_delete_case_imap" "2"
		Result="0"
	else	
		prints "ERROR:Special delete for IMAP is not working fine. Please check manually." "special_delete_case_imap" "1"
		Result="1"
	fi
	set_config_keys "/*/imapserv/enableSpecialDelete" "false" "1"
} 
 
#TestScenarios for rfc822 ; User3 is used which has 7 messages(Sent in SMTP test cases)
#testcase 42
function TC_fetch_single_message_rfc822(){
	start_time_tc TC_fetch_single_message_rfc822_tc
	
	
	imap_fetch "$user3" "1"      
	summary "IMAP:TC_fetch_single_message_rfc822" $Result
}
#testcase 43
function TC_fetch_multiple_message_rfc822(){
	start_time_tc TC_fetch_multiple_message_rfc822_tc
	
	imap_fetch "$user3" "1,2,3"      
	summary "IMAP:TC_fetch_multiple_message_rfc822" $Result
}
#testcase 44
function TC_fetch_range_message_rfc822(){
	start_time_tc TC_fetch_range_message_rfc822_tc
	
	imap_fetch "$user3" "1:3"      
	summary "IMAP:TC_fetch_range_message_rfc822" $Result
}
#testcase 45
function TC_fetch_all_message_rfc822(){
	start_time_tc TC_fetch_all_message_rfc822_tc
	
	imap_fetch "$user3" "1:*"      
	summary "IMAP:TC_fetch_all_message_rfc822" $Result
}
#testcase 46
function TC_fetch_option1_message_rfc822(){
	start_time_tc TC_fetch_option1_message_rfc822_tc
	
	imap_fetch "$user3" "1:2,3:3"      
	summary "IMAP:TC_fetch_option1_message_rfc822" $Result
}
#testcase 47
function TC_fetch_option2_message_rfc822(){
	start_time_tc TC_fetch_option2_message_rfc822_tc
	
	imap_fetch "$user3" "1:2,3"      
	summary "IMAP:TC_fetch_option2_message_rfc822" $Result
}
#TestScenarios for body[text] ; User3 is used which has 7 messages(Sent in SMTP test cases)
#testcase 48
function TC_fetch_single_message_body_text(){
	start_time_tc TC_fetch_single_message_body_text_tc
	
	imap_fetch "$user3" "1" "body[text]"   
	summary "IMAP:TC_fetch_single_message_body_text" $Result
}
# testcase 49
function TC_fetch_multiple_message_body_text(){
	start_time_tc TC_fetch_multiple_message_body_text_tc
	
	imap_fetch "$user3" "1,2,3" "body[text]"    
	summary "IMAP:TC_fetch_multiple_message_body_text" $Result
}
#testcase 50
function TC_fetch_range_message_body_text(){
	start_time_tc TC_fetch_range_message_body_text_tc
	
	imap_fetch "$user3" "1:3" "body[text]"      
	summary "IMAP:TC_fetch_range_message_body_text" $Result
}
# testcase 51
function TC_fetch_all_message_body_text(){
	start_time_tc TC_fetch_all_message_body_text_tc
	
	imap_fetch "$user3" "1:*" "body[text]"      
	summary "IMAP:TC_fetch_all_message_body_text" $Result
}
# testcase 52
function TC_fetch_option1_message_body_text(){
	start_time_tc TC_fetch_option1_message_body_text_tc
	
	imap_fetch "$user3" "1:2,3:3" "body[text]"     
	summary "IMAP:TC_fetch_option1_message_body_text" $Result
}
#testcase 53
function TC_fetch_option2_message_body_text(){
	start_time_tc TC_fetch_option2_message_body_text_tc
	
	imap_fetch "$user3" "1:2,3" "body[text]"    
	summary "IMAP:TC_fetch_option2_message_body_text" $Result
}
#TestScenarios for body[header] ; User3 is used which has 7 messages(Sent in SMTP test cases)
#testcase 54
function TC_fetch_single_message_body_header(){
    start_time_tc TC_fetch_single_message_body_header_tc
            
    imap_fetch "$user3" "1" "body[header]"
    summary "IMAP:TC_fetch_single_message_body_header" $Result
}
# testcase 55
function TC_fetch_multiple_message_body_header(){
    start_time_tc TC_fetch_multiple_message_body_header_tc
	imap_fetch "$user3" "1,2,3" "body[header]"
	summary "IMAP:TC_fetch_multiple_message_body_header" $Result
}
# testcase 56
function TC_fetch_range_message_body_header(){
	start_time_tc TC_fetch_range_message_body_header_tc
	imap_fetch "$user3" "1:3" "body[header]"
	summary "IMAP:TC_fetch_range_message_body_header" $Result
}
#testcase 57 
function TC_fetch_all_message_body_header(){
	start_time_tc TC_fetch_all_message_body_header_tc
	imap_fetch "$user3" "1:*" "body[header]"
	summary "IMAP:TC_fetch_all_message_body_header" $Result
}
#testcase58
function TC_fetch_option1_message_body_header(){
	start_time_tc TC_fetch_option1_message_body_header_tc
	imap_fetch "$user3" "1:2,3:3" "body[header]"
	summary "IMAP:TC_fetch_option1_message_body_header" $Result
}
# testcase 59
function TC_fetch_option2_message_body_header(){
	start_time_tc TC_fetch_option2_message_body_header_tc
	imap_fetch "$user3" "1:2,3" "body[header]"
	summary "IMAP:TC_fetch_option2_message_body_header" $Result
}
#TestScenarios for envelope ; User3 is used which has 7 messages(Sent in SMTP test cases)
#testcase 60
function TC_fetch_single_message_envelope(){
	start_time_tc TC_fetch_single_message_envelope_tc
	imap_fetch "$user3" "1" "envelope"
	summary "IMAP:TC_fetch_single_message_envelope" $Result
}
# testcase 61
function TC_fetch_multiple_message_envelope(){
	start_time_tc TC_fetch_multiple_message_envelope_tc
	imap_fetch "$user3" "1,2,3" "envelope"
	summary "IMAP:TC_fetch_multiple_message_envelope" $Result
}
# testcase 62 
function TC_fetch_range_message_envelope(){
	start_time_tc TC_fetch_range_message_envelope_tc
	imap_fetch "$user3" "1:3" "envelope"
	summary "IMAP:TC_fetch_range_message_envelope" $Result
}
# testcase 63
function TC_fetch_all_message_envelope(){
	start_time_tc TC_fetch_all_message_envelope_tc
	imap_fetch "$user3" "1:*" "envelope"
	summary "IMAP:TC_fetch_all_message_envelope" $Result
}
# testcase 64
function TC_fetch_option1_message_envelope(){
	start_time_tc TC_fetch_option1_message_envelope_tc
	imap_fetch "$user3" "1:2,3:3" "envelope"
	summary "IMAP:TC_fetch_option1_message_envelope" $Result
}
# testcase 65
function TC_fetch_option2_message_envelope(){
	start_time_tc TC_fetch_option2_message_envelope_tc
	imap_fetch "$user3" "1:2,3" "envelope"
	summary "IMAP:TC_fetch_option2_message_envelope" $Result
}
#TestScenarios for flags ; User3 is used which has 7 messages(Sent in SMTP test cases)
#testcase 66
function TC_fetch_single_message_flags(){
	start_time_tc TC_fetch_single_message_flags_tc
	imap_fetch "$user3" "1" "flags"
	summary "IMAP:TC_fetch_single_message_flags" $Result
}
# testcase 67
function TC_fetch_multiple_message_flags(){
    start_time_tc TC_fetch_multiple_message_flags_tc
	imap_fetch "$user3" "1,2,3" "flags"
	summary "IMAP:TC_fetch_multiple_message_flags" $Result
}
# testcase 68
function TC_fetch_range_message_flags(){
	start_time_tc TC_fetch_range_message_flags_tc
	imap_fetch "$user3" "1:3" "flags"
	summary "IMAP:TC_fetch_range_message_flags" $Result
}
# testcase 69
function TC_fetch_all_message_flags(){
	start_time_tc TC_fetch_all_message_flags_tc
	imap_fetch "$user3" "1:*" "flags"
	summary "IMAP:TC_fetch_all_message_flags" $Result
}
# testcase 70
function TC_fetch_option1_message_flags(){
	start_time_tc TC_fetch_option1_message_flags_tc
	imap_fetch "$user3" "1:2,3:3" "flags"
	summary "IMAP:TC_fetch_option1_message_flags" $Result
}
# testcase 71
function TC_fetch_option2_message_flags(){
	start_time_tc TC_fetch_option2_message_flags_tc
	imap_fetch "$user3" "1:2,3" "flags"
	summary "IMAP:TC_fetch_option2_message_flags" $Result
}
#TestScenarios for UID ; User3 is used which has 7 messages(Sent in SMTP test cases)
# testcase 72
function TC_fetch_single_message_uid(){
	start_time_tc TC_fetch_single_message_uid_tc
	
	imap_fetch "$user3" "1" "uid"   
	summary "IMAP:TC_fetch_single_message_uid" $Result
}
# testcase 73
function TC_fetch_multiple_message_uid(){
	start_time_tc TC_fetch_multiple_message_uid_tc
	
	imap_fetch "$user3" "1,2,3" "uid" 
	summary "IMAP:TC_fetch_multiple_message_uid" $Result
}
# testcase 74
function TC_fetch_range_message_uid(){
	start_time_tc TC_fetch_range_message_uid_tc
	
	imap_fetch "$user3" "1:3" "uid"    
	summary "IMAP:TC_fetch_range_message_uid" $Result
}
# test case 75 
function TC_fetch_all_message_uid(){
	start_time_tc TC_fetch_all_message_uid_tc
	
	imap_fetch "$user3" "1:*" "uid"     
	summary "IMAP:TC_fetch_all_message_uid" $Result
}
# testcase 76
function TC_fetch_option1_message_uid(){
	start_time_tc TC_fetch_option1_message_uid_tc
	
	imap_fetch "$user3" "1:2,3:3" "uid"   
	summary "IMAP:TC_fetch_option1_message_uid" $Result
}
# testcase 77
function TC_fetch_option2_message_uid(){
	start_time_tc TC_fetch_option2_message_uid_tc
	
	imap_fetch "$user3" "1:2,3" "uid"     
	summary "IMAP:TC_fetch_option2_message_uid" $Result
} 
#TestScenarios for FULL ; User3 is used which has 7 messages(Sent in SMTP test cases)
# testcase 78
function TC_fetch_single_message_full(){
	start_time_tc TC_fetch_single_message_full_tc
	
	imap_fetch "$user3" "1" "full"   
	summary "IMAP:TC_fetch_single_message_full" $Result
}
# test case 79
function TC_fetch_multiple_message_full(){
	start_time_tc TC_fetch_multiple_message_full_tc
	
	imap_fetch "$user3" "1,2,3" "full" 
	summary "IMAP:TC_fetch_multiple_message_full" $Result
}
# testcase 80
function TC_fetch_range_message_full(){
	start_time_tc TC_fetch_range_message_full_tc
	
	imap_fetch "$user3" "1:3" "full"    
	summary "IMAP:TC_fetch_range_message_full" $Result
}
# testcase 81
function TC_fetch_all_message_full(){
	start_time_tc TC_fetch_all_message_full_tc
	
	imap_fetch "$user3" "1:*" "full"     
	summary "IMAP:TC_fetch_all_message_full" $Result
}
# testcase 82
function TC_fetch_option1_message_full(){
	start_time_tc TC_fetch_option1_message_full_tc
	
	imap_fetch "$user3" "1:2,3:3" "full"   
	summary "IMAP:TC_fetch_option1_message_full" $Result
}
# testcase 83
function TC_fetch_option2_message_full(){
	start_time_tc TC_fetch_option2_message_full_tc
	
	imap_fetch "$user3" "1:2,3" "full"     
	summary "IMAP:TC_fetch_option2_message_full" $Result
} 

# mx9.5 new feature,body preview
#firstline-empty-message-body
function TC_fetch_firstline_data_empty_body(){
	start_time_tc "TC_fetch_firstline_data_empty_body"
	#enable XFIRSTLINE key: 
	set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/empty_body.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FETCH (FIRSTLINE (\"\")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_empty_body" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 
  
#firstline-empty-message-body-uidfetch
function TC_uid_fetch_firstline_data_empty_body(){
	start_time_tc "TC_uid_fetch_firstline_data_empty_body"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/empty_body.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FETCH (FIRSTLINE (\"\")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_empty_body" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 
  
#firstline-empty-message-body-attachment
function TC_fetch_firstline_data_empty_body_with_attachment(){
	start_time_tc "TC_fetch_firstline_data_empty_body_with_attachment"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/empty_body_with_attachment.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FETCH (FIRSTLINE (\"\")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_empty_body_with_attachment" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#firstline-empty-message-body-attachment-uidfetch
function TC_uid_fetch_firstline_data_empty_body_with_attachment(){
	start_time_tc "TC_uid_fetch_firstline_data_empty_body_with_attachment"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/empty_body_with_attachment.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FETCH (FIRSTLINE (\"\")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_empty_body_with_attachment" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit
function TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_less_than_80_CTE_7bit.txt
	imap_fetch "$user21" "1:2" "firstline"    
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"، ويمكن تح No body! いくつにな  我们是中国人， \")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit-uidfetch
function TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_less_than_80_CTE_7bit.txt
	imap_uid_fetch "$user21" "1:*" "firstline"    
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"، ويمكن تح No body! いくつにな  我们是中国人， \")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_7bit" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 



#TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64
function TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_less_than_80_CTE_base64.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"، ويمكن تح No body! いくつにな  我们是中国人， \")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64-uidfetch
function TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_less_than_80_CTE_base64.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"، ويمكن تح No body! いくつにな  我们是中国人， \")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_base64" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 


#TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt
function TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_less_than_80_CTE_qt.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"، ويمكن تح No body! いくつにな  我们是中国人， \")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt-uidfetch
function TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_less_than_80_CTE_qt.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"، ويمكن تح No body! いくつにな  我们是中国人， \")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_less_than_80_CTE_qt" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 



#TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit
function TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_equals_80_CTE_7bit.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit
function TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_equals_80_CTE_7bit.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_7bit" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 




#TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64
function TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_equals_80_CTE_base64.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_equals_80_CTE_base64-uidfetch
function TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_base64(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_base64"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_equals_80_CTE_base64.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_base64" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 


#TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt
function TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_equals_80_CTE_qt.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_equals_80_CTE_qt-uidfetch
function TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_qt(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_qt"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_equals_80_CTE_qt.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_equals_80_CTE_qt" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 



#TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit
function TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_more_than_80_CTE_7bit.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit-uidfetch
function TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_more_than_80_CTE_7bit.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_7bit" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 



#TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64
function TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_more_than_80_CTE_base64.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64-uidfetch
function TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_more_than_80_CTE_base64.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_base64" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 



#TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt
function TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt(){
	start_time_tc "TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_more_than_80_CTE_qt.txt
	imap_fetch "$user21" "1:2" "firstline"     
	cat imapfetch.txt  >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt" $Result
	
	#disable XFIRSTLINE key:
	#set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 

#TC_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt-uidfetch
function TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt(){
	start_time_tc "TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt"
	#enable XFIRSTLINE key: 
	#set_config_keys "/*/common/enableXFIRSTLINE" "true"
	#clear current messages in account
	#immsgdelete  ${user21}@openwave.com  -all
	#sleep 2
	#deliever message with empty message body to Sanity21@openwave.com
	#./sm.pl    -u ${user21}@openwave.com -c 2   firstline_messages/UTF8_body_more_than_80_CTE_qt.txt
	imap_uid_fetch "$user21" "1:*" "firstline"     
	cat imapuidfetch.txt >>debug.log
	firstlinedata_count=`grep "FIRSTLINE (\"qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.txt |wc -l`
	if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
		Result=0
	else
	  Result=1
	fi
	summary "IMAP:TC_uid_fetch_firstline_data_UTF8_body_more_than_80_CTE_qt" $Result
	
	#disable XFIRSTLINE key:
	set_config_keys "/*/common/enableXFIRSTLINE" "false"
} 



# mx9.5 new feature,condstore
function TC_fetch_modseq(){
	start_time_tc "TC_fetch_modseq"
	#change serviceBlackoutSeconds to a small value,otherwise emails will be defered.
	#set_config_keys "/*/mss/serviceBlackoutSeconds" "3" "1"
	#enable condstore
	echo "enable condstore............."
	set_config_keys "/*/common/enableCONDSTORE" "true"  "1"
	sleep 3
	#clear current imilbox in ${user22}@openwave.com 
	immsgdelete  ${user22}@openwave.com  -all
	#deliever 3 messages to $user22@openwave.com
	./sm.pl  -u ${user22}@openwave.com   -c 3 1K 
	#imboxstats  ${user22}@openwave.com  
	imap_fetch "$user22" "2:3" "modseq"   
	cat imapfetch.txt  
	m1=`grep MODSEQ  imapfetch.txt |head -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
	m2=`grep MODSEQ  imapfetch.txt |tail -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
	((m3=$m1*$m2))
	if [ $m3 -gt 0 -a $Result -eq 0 ];then
		Result=0
	else
		Result=1
	fi
	summary "IMAP:TC_fetch_modseq" $Result
	#disable condstore ,revert key
	echo "disable condstore ...................."
	set_config_keys "/*/common/enableCONDSTORE" "false"  "1"
	sleep 3
	#change key back
	#set_config_keys "/*/mss/serviceBlackoutSeconds" "30" "1"
	#sleep 10
} 

#after imboxmaint ,modseq ID should become UID
function TC_fetch_modseq_for_upgradded_accounts(){
	start_time_tc "TC_fetch_modseq_for_upgradded_accounts"
	#change serviceBlackoutSeconds to a small value,otherwise emails will be defered.
	#set_config_keys "/*/mss/serviceBlackoutSeconds" "3" "1"
	#enable condstore
	#set_config_keys "/*/common/enableCONDSTORE" "true"  "1"
	#sleep 3
	#deliever 3 messages to $user22@openwave.com
	#./sm.pl  -u ${user22}@openwave.com   -c 3 1K 
	#imboxstats  ${user22}@openwave.com  
	#add  3 messages
	./sm.pl  -u ${user22}@openwave.com   -c 3 1K 
	#enable modseq
	echo "enable condstore again ..................."
	set_config_keys "/*/common/enableCONDSTORE" "true"  "1"
	sleep 3
	imap_fetch "$user22" "4:5" "modseq"
	cat imapfetch.txt
	mm1=`grep MODSEQ  imapfetch.txt |head -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
	mm2=`grep MODSEQ  imapfetch.txt |tail -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
	#mm1 and mm2 should eauals 0
	let mm3=mm1+mm2
	#add key :
	maint_cn=$(cat $INTERMAIL/config/config.db | grep clusterName|grep -v imboxmaint | cut -d "/" -f2 | cut -d "-" -f2) 
	set_config_keys "/*/imboxmaint/clusterName" "$maint_cn"
	#imboxmaint
	#echo "running imboxmaint ....................."
	#imboxmaint_fn is a defiend function ,check functin imboxmaint_fn
	imboxmaint_fn   ${user22}@openwave.com 
	#sleep 3
	imap_fetch "$user22" "4:5" "modseq"   
	cat imapfetch.txt  
	mm5=`grep MODSEQ  imapfetch.txt |head -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
	mm6=`grep MODSEQ  imapfetch.txt |tail -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
	if [ $mm3 -eq 0 -a $mm5 -ge 1000 -a $mm6 -ge 1000 -a $Result -eq 0 ];then
		Result=0
	else
		Result=1
	fi
	summary "IMAP:TC_fetch_modseq_for_upgradded_accounts" $Result
	#disable condstore ,revert key
	echo "disable condstore finally ............................."
	set_config_keys "/*/common/enableCONDSTORE" "false"  "1"
	sleep 3
	#change key back
	#set_config_keys "/*/mss/serviceBlackoutSeconds" "30" "1"
	#sleep 10
} 
  
#TestScenarios for Creating folder "CREATE" command
# testcase 84
function TC_create_systemfolder(){
	start_time_tc TC_create_systemfolder_tc
	
	imap_create "$user7" "Trash"
	summary "IMAP:TC_create_systemfolder" $Result
}
# testcase 85
function TC_create_customfolder(){
	
	start_time_tc TC_create_customfolder_tc
	
	imap_create "$user7" "New_folder"
	summary "IMAP:TC_create_customfolder" $Result
}
# testcase 86
function TC_create_nested_customfolder(){
	start_time_tc TC_create_nested_customfolder_tc
	
	imap_create "$user7" "a/b"
	summary "IMAP:TC_create_nested_customfolder" $Result
}
 # testcase 87
 function TC_create_nested_systemfolder(){
	start_time_tc TC_create_nested_systemfolder_tc
	
	imap_create "$user7" "Trash/Trash"
	summary "IMAP:TC_create_nested_systemfolder" $Result
}

#folder share functions:
function TC_shareFolder_system(){
	start_time_tc TC_shareFolder_system_tc
	imap_append "$user7" "Trash" "{9}" "xcvbnjhyt"
	shareFolder "$mxoshost_port" "$user7" "$user8"  "Trash"
	imctrl  allhosts  killStart mss   &> restart.txt
	sleep 5
	imap_fetch "$user8" "1" "rfc822" "${user7}-Trash"
	cat imapfetch.txt  >me
	target=`grep -i "xcvbnjhyt" imapfetch.txt |wc -l`
	if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		Result=0
	else
		Result=1
	fi
	>imapfetch.txt
	summary "IMAP:TC_shareFolder_system" $Result
	
	#with domain
	#with key enabled:/*/mxos/returnUserNameWithDomain
	set_config_keys "/*/mxos/returnUserNameWithDomain" "true"
	sleep 1
	imap_fetch "$user8" "1" "rfc822" "${user7}@openwave.com-Trash"
	cat imapfetch.txt  >me2
	target=`grep -i "xcvbnjhyt" imapfetch.txt |wc -l`
	if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		Result=0
	else
		Result=1
	fi
	summary "IMAP:TC_shareFolder_system_with_domain" $Result
	set_config_keys "/*/mxos/returnUserNameWithDomain" "false"
}


function TC_shareFolder_custom(){
	start_time_tc TC_shareFolder_custom_tc
	imap_append "$user7" "New_folder" "{9}" "ccvbnjhyt"
	shareFolder "$mxoshost_port" "$user7" "$user8"  "New_folder"
	imap_fetch "$user8" "1" "rfc822" "${user7}-New_folder"
	cat imapfetch.txt  >me3
	target=`grep -i "ccvbnjhyt" imapfetch.txt |wc -l`
	if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		Result=0
	else
		Result=1
	fi
	>imapfetch.txt
	summary "IMAP:TC_shareFolder_custom" $Result
	
	#with domain
	#with key enabled:/*/mxos/returnUserNameWithDomain
	set_config_keys "/*/mxos/returnUserNameWithDomain" "true"
	sleep 1
	imap_fetch "$user8" "1" "rfc822" "${user7}@openwave.com-New_folder"
	cat imapfetch.txt  >me4
	target=`grep -i "ccvbnjhyt" imapfetch.txt |wc -l`
	if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		Result=0
	else
		Result=1
	fi
	summary "IMAP:TC_shareFolder_custom_with_domain" $Result
	set_config_keys "/*/mxos/returnUserNameWithDomain" "false"
}

function TC_shareFolder_nested_customfolder(){
	start_time_tc TC_shareFolder_nested_customfolder_tc
	imap_append "$user7" "a/b" "{9}" "mcvbnjhyt"
	shareFolder "$mxoshost_port" "$user7" "$user8"  "a/b"
	imap_fetch "$user8" "1" "rfc822" "${user7}-a/b"
	#cat imapfetch.txt  >me5
	target=`grep -i "mcvbnjhyt" imapfetch.txt |wc -l`
	if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		Result=0
	else
		Result=1
	fi
	>imapfetch.txt
	summary "IMAP:TC_shareFolder_nested_customfolder" $Result
	
	#with domain
	#with key enabled:/*/mxos/returnUserNameWithDomain
	set_config_keys "/*/mxos/returnUserNameWithDomain" "true"
	sleep 1
	imap_fetch "$user8" "1" "rfc822" "${user7}@openwave.com-a/b"
	#cat imapfetch.txt  >me6
	target=`grep -i "mcvbnjhyt" imapfetch.txt |wc -l`
	if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		Result=0
	else
		Result=1
	fi
	summary "IMAP:TC_shareFolder_nested_customfolder_with_domain" $Result
	set_config_keys "/*/mxos/returnUserNameWithDomain" "false"
}


function TC_shareFolder_nested_systemfolder(){
	start_time_tc TC_shareFolder_nested_systemfolder_tc
	imap_append "$user7" "Trash/Trash" "{9}" "qcvbnjhyt"
	shareFolder "$mxoshost_port" "$user7" "$user8"  "Trash/Trash"
	imap_fetch "$user8" "1" "rfc822" "${user7}-Trash/Trash"
	#cat imapfetch.txt  >me7
	target=`grep -i "qcvbnjhyt" imapfetch.txt |wc -l`
	if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		Result=0
	else
		Result=1
	fi
	>imapfetch.txt
	summary "IMAP:TC_shareFolder_nested_systemfolder" $Result
	
	#with domain
	#with key enabled:/*/mxos/returnUserNameWithDomain
	set_config_keys "/*/mxos/returnUserNameWithDomain" "true"
	sleep 1
	imap_fetch "$user8" "1" "rfc822" "${user7}@openwave.com-Trash/Trash"
	cat imapfetch.txt  >me8
	target=`grep -i "qcvbnjhyt" imapfetch.txt |wc -l`
	if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		Result=0
	else
		Result=1
	fi
	summary "IMAP:TC_shareFolder_nested_systemfolder_with_domain" $Result
	set_config_keys "/*/mxos/returnUserNameWithDomain" "false"
}


#unshare folder functions
function TC_UnshareFolder_nested_systemfolder(){
	start_time_tc TC_UnshareFolder_nested_systemfolder_tc
	unshareFolder "$mxoshost_port" "$user7" "$user8"  "Trash/Trash"
	summary "IMAP:TC_UnshareFolder_nested_systemfolder" $Result
}

	
function TC_UnshareFolder_nested_customfolder(){
  start_time_tc TC_UnshareFolder_nested_customfolder_tc
	unshareFolder "$mxoshost_port" "$user7" "$user8"  "a/b"
	summary "IMAP:TC_UnshareFolder_nested_customfolder" $Result
}
	
	
function TC_UnshareFolder_custom(){
  start_time_tc TC_UnshareFolder_custom_tc
	unshareFolder "$mxoshost_port" "$user7" "$user8"  "New_folder"
	summary "IMAP:TC_UnshareFolder_custom" $Result
}

	
function	TC_UnshareFolder_system(){
  start_time_tc TC_UnshareFolder_system_tc
	unshareFolder "$mxoshost_port" "$user7" "$user8"  "Trash"
	summary "IMAP:TC_UnshareFolder_system" $Result
}




#TestScenarios for Creating folder "DELETE" command
# testcase 88
function TC_delete_systemfolder(){
	start_time_tc TC_delete_systemfolder_tc
	
	imap_delete "$user7" "Trash"
	summary "IMAP:TC_delete_systemfolder" $Result
}
# testcase 89
function TC_delete_customfolder(){
	
	start_time_tc TC_delete_customfolder_tc
	
	imap_delete "$user7" "New_folder"
	summary "IMAP:TC_delete_customfolder" $Result
}
# testcase 90
function TC_delete_nested_customfolder(){
	start_time_tc TC_delete_nested_customfolder_tc
	
	imap_delete "$user7" "a/b"
	summary "IMAP:TC_delete_nested_customfolder" $Result
}
 # testcase 91
function TC_delete_nested_systemfolder(){
	start_time_tc TC_delete_nested_systemfolder_tc
	
	imap_delete "$user7" "Trash/Trash"
	summary "IMAP:TC_delete_nested_systemfolder" $Result
}
#TestScenarios for "COPY" command
# testcase 92
function TC_copy_INBOXto_Trash(){
	
	start_time_tc TC_copy_INBOXto_Trash_tc
	
	mail_send "$user4" "small" "4"
	imap_copy "$user4" "2" "Trash" "INBOX"
		
	summary "IMAP:TC_copy_INBOXto_Trash" $Result
	immsgdelete_utility "$user4" "-all"
}
# testcase 93
function TC_copy_Trashto_SentMail(){
	start_time_tc TC_copy_Trashto_SentMail_tc
	
	mail_send "$user4" "small" "4"
	imap_copy "$user4" "2" "Trash" "INBOX"
	imap_copy "$user4" "1" "SentMail" "Trash" 
		
	summary "IMAP:TC_copy_Trashto_SentMail" $Result
	immsgdelete_utility "$user4" "-all"
}
# testcase 94
function TC_copy_INBOX_customfolder(){
	start_time_tc TC_copy_INBOX_customfolder_tc
	
	mail_send "$user4" "small" "2"
	imap_create "$user4" "new1"
	imap_copy "$user4" "2" "new1" "INBOX"
		
	summary "IMAP:TC_copy_INBOX_customfolder" $Result
	immsgdelete_utility "$user4" "-all"
}
# testcase 95
function TC_copy_customfolder_otherfolder(){
	
	start_time_tc TC_copy_customfolder_otherfolder_tc
	
	mail_send "$user4" "small" "4"
	imap_create "$user4" "folder1"
	imap_create "$user4" "folder2"
	imap_copy "$user4" "3" "folder1" "INBOX"
	imap_copy "$user4" "3" "folder2" "folder1"
		
	summary "IMAP:TC_copy_customfolder_otherfolder" $Result
	immsgdelete_utility "$user4" "-all"
}
#TestScenarios for "APPEND" command
# testcase 96
function TC_append_systemfolder(){
	start_time_tc TC_append_systemfolder_tc
	
	
	mail_send "$user8" "small" "1"
	imap_append "$user8" "INBOX" "{2}" "Hi"
	summary "IMAP:TC_append_systemfolder" $Result
	
}
# testcase 97
function TC_append_customfolder(){
	start_time_tc TC_append_customfolder_tc
	
	imap_create "$user8" "folder12"
	imap_append "$user8" "folder12" "{3}" "Hey"
	summary "IMAP:TC_append_customfolder" $Result
	
}
#TestScenarios for "RENAME" command
 # testcase 98
function TC_rename_systemfolder_customfolder_Trash(){
	start_time_tc TC_rename_systemfolder_customfolder_Trash_tc
	
	imap_rename "$user10" "Trash" "new_Trash"
	summary "IMAP:TC_rename_systemfolder_customfolder_Trash" $Result
	imap_delete "$user10" "new_Trash"
}
# testcase 99
function TC_rename_systemfolder_customfolder_Inbox(){
	start_time_tc TC_rename_systemfolder_customfolder_Inbox_tc
	
	imap_rename "$user10" "inbox" "new_Inbox"
	summary "IMAP:TC_rename_systemfolder_customfolder_Inbox" $Result
	imap_delete "$user10" "new_Inbox"
}
# testcase 100
function TC_rename_systemfolder_customfolder_SentMail(){
	start_time_tc TC_rename_systemfolder_customfolder_tc
	
	imap_rename "$user10" "SentMail" "new_SentMail"
	summary "IMAP:TC_rename_systemfolder_customfolder_SentMail" $Result
	imap_delete "$user10" "new_SentMail"
}
# testcase 101
function TC_rename_customfolder_systemfolder_SentMail(){
	start_time_tc TC_rename_customfolder_systemfolder_SentMail_tc
	
	imap_create "$user10" "my_folder"
	imap_rename "$user10" "my_folder" "SentMail"
	
	summary "IMAP:TC_rename_customfolder_systemfolder_SentMail" $Result
	imap_delete "$user10" "my_folder"
}
# testcase 102
function TC_rename_customfolder_systemfolder_Inbox(){
	start_time_tc TC_rename_customfolder_systemfolder_Inbox_tc
	
	imap_create "$user10" "my_folder"
	imap_rename "$user10" "my_folder" "INBOX"
	
	summary "IMAP:TC_rename_customfolder_systemfolder_Inbox" $Result
	imap_delete "$user10" "my_folder"
}
# testcase 103
function TC_rename_customfolder_systemfolder_Trash(){
	start_time_tc TC_rename_customfolder_systemfolder_Trash_tc
	
	imap_create "$user10" "my_folder"
	imap_rename "$user10" "my_folder" "Trash"
	summary "IMAP:TC_rename_customfolder_systemfolder_Trash" $Result
	imap_delete "$user10" "my_folder"
}
# testcase 104
function TC_rename_customfolder_newfolder(){
	start_time_tc TC_rename_customfolder_newfolder_tc
	
	imap_create "$user10" "my_folder"
	imap_rename "$user10" "my_folder" "my_folder1"
	
	summary "IMAP:TC_rename_customfolder_newfolder" $Result
	imap_delete "$user10" "my_folder1"
}
# testcase 104
function TC_rename_samefoldername(){
	start_time_tc TC_rename_customfolder_newfolder_tc
	
	imap_create "$user10" "my_folder2"
	imap_rename "$user10" "my_folder2" "my_folder2"
	
	summary "IMAP:TC_rename_customfolder_samefoldername" $Result
	imap_delete "$user10" "my_folder2"
}
#TestScenarios for "SEARCH" command
# testcase 106
function TC_search_all(){
	
	start_time_tc TC_search_all_tc
	
	imdbcontrol sac $user9 openwave.com mailquotamaxmsgkb 0
	imdbcontrol sac $user9 openwave.com mailquotatotkb 0
	mail_send "$user9" "small" "1"
  mail1=$Result
	mail_send "$user9" "large" "1"
  mail2=$Result
  if [ $mail1 == 0 -a $mail2 == 0 ];then
      imap_search "$user9" "INBOX" "all"
	    verify_imapsearch=$(cat imapsearch.txt | grep -i "SEARCH" | grep -i "1 2" | wc -l)
	    verify_imapsearch=`echo $verify_imapsearch | tr -d " "`
	    echo "verify_imapsearch=$verify_imapsearch"  >>debug.log
	    if [ "$verify_imapsearch" == "1" ]
	    then
				prints "IMAP SEARCH for $imapUser is successful" "TC_search_all" "2"
				Result="0"
	    else
				prints "-ERR IMAP SEARCH for $imapUser is unsuccessful" "TC_search_all" "1"
				Result="1"
      fi
   else 
        prints "-ERR mail delivered unsuccessfully" "mail_send" "1"
        Result="1"
   fi
	
	summary "IMAP:TC_search_all" $Result
	immsgdelete_utility "$user9" "-all"
}

function TC_search_smaller(){
	start_time_tc TC_search_smaller_tc
	
	imdbcontrol sac $user9 openwave.com mailquotamaxmsgkb 0
	imdbcontrol sac $user9 openwave.com mailquotatotkb 0
	mail_send "$user9" "small" "1"
        mail1=$Result
	mail_send "$user9" "large" "1"
        mail2=$Result
        if [ $mail1 == 0 -a $mail2 == 0 ];then
	    imap_search "$user9" "INBOX" "smaller" "1000"
	    verify_imapsearch=$(cat imapsearch.txt | grep -i "SEARCH" | grep -i "1" | wc -l)
	    verify_imapsearch=`echo $verify_imapsearch | tr -d " "`
	    if [ "$verify_imapsearch" == "1" ]
	    then
		prints "IMAP SEARCH for $imapUser is successful" "TC_search_smaller" "2"
		Result="0"
	    else
		prints "-ERR IMAP SEARCH for $imapUser is unsuccessful" "TC_search_smaller" "1"
		Result="1"
	    fi
        else
            prints "-ERR mail sent unsuccessful" "mail_send" "1"
            Result="1"
        fi
	
	summary "IMAP:TC_search_smaller" $Result
	immsgdelete_utility "$user9" "-all"
}

function TC_search_larger(){
	start_time_tc TC_search_larger_tc
	imdbcontrol sac $user9 openwave.com mailquotamaxmsgkb 0
	imdbcontrol sac $user9 openwave.com mailquotatotkb 0
	
	mail_send "$user9" "small" "1"
        mail1=$Result
	mail_send "$user9" "large" "1"
        mail2=$Result
        if [ $mail1 == 0 -a $mail2 == 0 ];then
	    imap_search "$user9" "INBOX" "larger" "1000"
	    verify_imapsearch=$(cat imapsearch.txt | grep -i "SEARCH" | grep -i "2" | wc -l)
	    verify_imapsearch=`echo $verify_imapsearch | tr -d " "`
	    if [ "$verify_imapsearch" == "1" ]
	    then
		prints "IMAP SEARCH for $imapUser is successful" "TC_search_larger" "2"
		Result="0"
	    else
		prints "-ERR IMAP SEARCH for $imapUser is unsuccessful" "TC_search_larger" "1"
		Result="1"
	    fi
        else
            prints "-ERR mail sent unsuccessful" "mail_send" "1"
            Result="1"
        fi
	summary "IMAP:TC_search_larger" $Result
	immsgdelete_utility "$user9" "-all"
}

function TC_search_From(){
	start_time_tc TC_search_From_tc
	imdbcontrol sac $user9 openwave.com mailquotamaxmsgkb 0
	imdbcontrol sac $user9 openwave.com mailquotatotkb 0
	mail_send "$user9" "small" "1"
        mail1=$Result
	mail_send "$user9" "large" "1"
        mail2=$Result
        if [ $mail1 == 0 -a $mail2 == 0 ];then
      
	    imap_search "$user9" "INBOX" "From" "$MAILFROM"
	    verify_imapsearch=$(cat imapsearch.txt | grep -i "SEARCH"| grep -i "1 2" | wc -l)
	    verify_imapsearch=`echo $verify_imapsearch | tr -d " "`
	    if [ "$verify_imapsearch" == "1" ]
	    then
		prints "IMAP SEARCH for $imapUser is successful" "TC_search_From" "2"
		Result="0"
	    else
		prints "-ERR IMAP SEARCH for $imapUser is unsuccessful" "TC_search_From" "1"
		Result="1"
	    fi
        else
            prints "-ERR mail sent unsuccessful" "mail_send" "1"
            Result="1"
        fi
	
	summary "IMAP:TC_search_From" $Result
	imdbcontrol sac $user9 openwave.com mailquotamaxmsgkb 100
	immsgdelete_utility "$user9" "-all"
}

function TC_search_OR(){
	start_time_tc TC_search_OR_tc
	
	imdbcontrol sac $user9 openwave.com mailquotamaxmsgkb 0
	imdbcontrol sac $user9 openwave.com mailquotatotkb 0
	mail_send "$user9" "small" "1"
  mail1=$Result
	mail_send "$user9" "large" "1"
  mail2=$Result
  if [ $mail1 == 0 -a $mail2 == 0 ];then
			imap_search "$user9" "INBOX" "OR" "old larger 1000"
	    verify_imapsearch=$(cat imapsearch.txt | grep -i "SEARCH"| grep -i "2" | wc -l)
	    verify_imapsearch=`echo $verify_imapsearch | tr -d " "`
	    if [ "$verify_imapsearch" == "1" ]
	    then
				prints "IMAP SEARCH for $imapUser is successful" "TC_search_OR" "2"
				Result="0"
	    else
				prints "-ERR IMAP SEARCH for $imapUser is unsuccessful" "TC_search_OR" "1"
				Result="1"
	    fi
   else
      prints "-ERR mail sent unsuccessful" "mail_send" "1"
      Result="1"
   fi
	
	summary "IMAP:TC_search_OR" $Result
	immsgdelete_utility "$user9" "-all"
}
#TestScenarios for "MOVE" command

function TC_move_INBOXto_SentMail(){
	
	start_time_tc TC_move_INBOXto_SentMail_tc
	
	mail_send "$user9" "small" "3"
	imap_move "$user9" "2" "SentMail" "INBOX"
	
	summary "IMAP:TC_move_INBOXto_SentMail" $Result
	immsgdelete_utility "$user9" "-all"
}
# testcase 112
function TC_move_Trashto_Customfolder(){
	start_time_tc TC_move_Trashto_Customfolder_tc
	
	mail_send "$user9" "small" "3"
    
	imap_create "$user9" "folder1"
	imap_move "$user9" "2" "Trash" "INBOX"
	imap_move "$user9" "1" "folder1" "Trash"
			
	summary "IMAP:TC_move_Trashto_Customfolder" $Result
	immsgdelete_utility "$user9" "-all"
}
# testcase 113
function TC_move_customfolder_otherfolder(){
	
	start_time_tc TC_move_customfolder_otherfolder_tc
	
	mail_send "$user9" "small" "4"
	imap_create "$user9" "folder11"
	imap_create "$user9" "folder2"
	imap_move "$user9" "3" "folder11" "INBOX"
	imap_move "$user9" "2" "folder2" "folder11"
		
	summary "IMAP:TC_move_customfolder_otherfolder" $Result
	immsgdelete_utility "$user9" "-all"
}
#TestScenarios for "STORE" command
# testcase 114
function TC_store_addflag(){
	start_time_tc TC_store_addflag_tc
	
	mail_send "$user9" "small" "1" 
	imap_store "$user9" "1" "+" "\Draft" "INBOX"
	
	summary "IMAP:TC_store_addflag" $Result
	immsgdelete_utility "$user9" "-all"
}
# testcase 115
function TC_store_removeflag(){
	start_time_tc TC_store_removeflag_tc
	
	mail_send "$user9" "small" "1"
	imap_store "$user9" "1" "+" "\Draft" "INBOX"
	imap_store "$user9" "1" "-" "\Draft" "INBOX"
	
	summary "IMAP:TC_store_removeflag" $Result
	immsgdelete_utility "$user9" "-all"
}
# testcase 116
function TC_store_add_invalidflag(){
	
	start_time_tc TC_store_add_invalidflag_tc
	
	mail_send "$user9" "small" "1"
	imap_store "$user9" "1" "+" "\TEMP" "INBOX"
	
	summary "IMAP:TC_store_add_invalidflag" $Result
	immsgdelete_utility "$user9" "-all"
}
# testcase 117
function TC_store_addkeywords(){
        start_time_tc TC_store_addkeywords_tc
        mail_send "$user9" "small" "1"
        imap_store "$user9" "1" "+" "aa" "INBOX"
        summary "IMAP:TC_store_addkeywords" $Result
        immsgdelete_utility "$user9" "-all"
}
# testcase 118
function TC_store_removekeywords(){
        start_time_tc TC_store_removekeywords_tc
        mail_send "$user9" "small" "3"
        imap_store "$user9" "3" "+" "bb" "INBOX"
        imap_store "$user9" "3" "-" "bb" "INBOX"
        summary "IMAP:TC_store_removekeywords" $Result
        immsgdelete_utility "$user9" "-all"
}
# TestScenarios for "SORT" command
#testcase 119
function TC_sort_from(){
  
	start_time_tc TC_sort_from_tc
	immsgdelete_utility "$user17" "-all"
	./sm.pl -u $user17 header1.txt 
	./sm.pl -u $user17 header2.txt 
	./sm.pl -u $user17 header3.txt 
	imap_sort "$user17" "INBOX" "from"
	#verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1002 1001 1000" | wc -l)
	verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1003 1002 1001" | wc -l)
	verify_imapsort=`echo $verify_imapsort | tr -d " "`
	if [ "$verify_imapsort" == "1" ]
	then
		prints "IMAP SORT for $imapUser is successful" "TC_sort_from" "2"
		Result="0"
	else
		prints "-ERR IMAP SORT for $imapUser is unsuccessful" "TC_sort_from" "1"
		Result="1"
	fi
	summary "IMAP:TC_sort_from" $Result
	immsgdelete_utility "$user17" "-all"
}
# testcase 120
function TC_sort_to(){
	start_time_tc TC_sort_to_tc
	./sm.pl -u $user17 header1.txt 
	./sm.pl -u $user17 header2.txt 
	./sm.pl -u $user17 header3.txt 
	imap_sort "$user17" "INBOX" "to"
	#verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1005 1003 1004" | wc -l)
	verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1006 1004 1005" | wc -l)
	verify_imapsort=`echo $verify_imapsort | tr -d " "`
	if [ "$verify_imapsort" == "1" ]
	then
		prints "IMAP SORT for $imapUser is successful" "TC_sort_to" "2"
		Result="0"
	else
		prints "-ERR IMAP SORT for $imapUser is unsuccessful" "TC_sort_to" "1"
		Result="1"
	fi
	summary "IMAP:TC_sort_to" $Result
	immsgdelete_utility "$user17" "-all"
}
# testacase 121
function TC_sort_subject(){
	start_time_tc TC_sort_subject_tc
	./sm.pl -u $user17 header1.txt 
	./sm.pl -u $user17 header2.txt 
	./sm.pl -u $user17 header3.txt 
	imap_sort "$user17" "INBOX" "subject"
	#verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1008 1007 1006" | wc -l)
	verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1009 1008 1007" | wc -l)
	verify_imapsort=`echo $verify_imapsort | tr -d " "`
	if [ "$verify_imapsort" == "1" ]
	then
		prints "IMAP SORT for $imapUser is successful" "TC_sort_subject" "2"
		Result="0"
	else
		prints "-ERR IMAP SORT for $imapUser is unsuccessful" "TC_sort_subject" "1"
		Result="1"
	fi
	summary "IMAP:TC_sort_subject" $Result
	immsgdelete_utility "$user17" "-all"
} 
# testcase 122
function TC_sort_size(){
	start_time_tc TC_sort_size_tc
	./sm.pl -u $user17 header1.txt 
	./sm.pl -u $user17 header2.txt 
	./sm.pl -u $user17 header3.txt 
	imap_sort "$user17" "INBOX" "arrival"
	#verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1009 1010 1011" | wc -l)
	verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1010 1011 1012" | wc -l)
	verify_imapsort=`echo $verify_imapsort | tr -d " "`
	if [ "$verify_imapsort" == "1" ]
	then
		prints "IMAP SORT for $imapUser is successful" "TC_sort_size" "2"
		Result="0"
	else
		prints "-ERR IMAP SORT for $imapUser is unsuccessful" "TC_sort_size" "1"
		Result="1"
	fi
	summary "IMAP:TC_sort_size" $Result
	immsgdelete_utility "$user17" "-all"
} 
#Test Cases for Utilities
#testcase 159
function TC_account_create(){
	
	start_time_tc TC_account_create_tc
	
	account_create_fn "Utility1"
	summary "UTILITIES:TC_account_create" $Result
	account_delete_fn "Utility1"
}
#testcase 160
function TC_account_delete(){
	
	start_time_tc TC_account_delete_tc
	
	account_create_fn "Utility2"
	summary "UTILITIES:TC_account_delete" $Result
	account_delete_fn "Utility2"
}
#testcase 161
function TC_imboxstats(){
	
	start_time_tc TC_imboxstats_tc
	
	account_create_fn "Utility3"
	imboxstats_fn "Utility3"
	mail_send "Utility3" "small" "1"
	imboxstats_fn "Utility3"
	
	summary "UTILITIES:TC_imboxstats" $Result
	account_delete_fn "Utility3"
}
#testcase 162
function TC_immsgdelete(){
	
	start_time_tc TC_immsgdelete_tc
	
	account_create_fn "Utility4"
	mail_send "Utility4" "small" "2"
	immsgdelete_utility "Utility4" "-all"
	
	summary "UTILITIES:TC_immsgdelete" $Result
	account_delete_fn "Utility4"
}
#testcase 163
function TC_immssdescms(){
	
	start_time_tc TC_immssdescms_tc
	
	account_create_fn "Utility5"
	mail_send "Utility5" "small" "2"
	immssdescms_utility "Utility5"
	
	summary "UTILITIES:TC_immssdescms" $Result
	account_delete_fn "Utility5"
}
#testcase 164
function TC_imfolderlist(){
	
	start_time_tc TC_imfolderlist_tc
	
	account_create_fn "Utility6"
	mail_send "Utility6" "small" "2"
	imfolderlist_utility "Utility6"
	
	summary "UTILITIES:TC_imfolderlist" $Result
	account_delete_fn "Utility6"
}
#testcase 165
function TC_immsgdump(){
	
	start_time_tc TC_immsgdump_tc
	
	account_create_fn "Utility7"
	mail_send "Utility7" "small" "2"
	immsgdump_utility "Utility7" "1"
	
	summary "UTILITIES:TC_immsgdump" $Result
	account_delete_fn "Utility7"
}
#testcase 166
function TC_immsgfind_Inbox(){
	
	start_time_tc TC_immsgfind_Inbox_tc
	
	account_create_fn "Utility8"
	immsgfind_utility "Utility8"
	
	summary "UTILITIES:TC_immsgfind_Inbox" $Result
	account_delete_fn "Utility8"
}
#testcase 167
function TC_immsgfind_Trash(){
	
	start_time_tc TC_immsgfind_Trash_tc
	
	account_create_fn "Utility9"
	./sm.pl -u Utility9 -f Trash -c 2 ./1K
	immssdescms Utility9@openwave.com > descms_Sanity1.txt
	msg_id=$(cat descms_Sanity1.txt | grep -i "Message ID" | cut -d " " -f2 | cut -d "=" -f2 | tail -1)
	msg_id=`echo $msg_id | tr -d " "`
	
	immsgfind $user_name@openwave.com "$msg_id" "/Trash" > log_immsgfind1.txt
	chk_msg_id=$(cat log_immsgfind1.txt | egrep -i "MESSAGE-ID" | wc -l)
	chk_msg_id=`echo $chk_msg_id | tr -d " "`
	cat log_immsgfind1.txt >> debug.log
	if [ "$chk_msg_id" == "1" ]
	then
		prints "immsgfind utility is working fine" "TC_immsgfind_Trash" "2"
		Result="0"
	else
		prints "ERROR: immsgfind utility output is not correct -'PT-57'" "TC_immsgfind_Trash" "1"
		Result="1"
	fi
	
	summary "UTILITIES:TC_immsgfind_Trash" $Result 
	account_delete_fn "Utility9"
}
#testcase 168
function TC_immsgtrace(){
	
	start_time_tc TC_immsgtrace_tc
	
	account_create_fn "Utility10"
	immsgtrace_utility "Utility10"
	
	summary "UTILITIES:TC_immsgtrace" $Result
	account_delete_fn "Utility10"
}
function TC_imboxattctrl(){
	
	start_time_tc TC_imboxattctrl_tc
	
	account_create_fn "Utility11"
	imboxattctrl_utility "Utility11" "1"
	
	summary "UTILITIES:TC_imboxattctrl" $Result
	account_delete_fn "Utility11"
}
function TC_imfilterctrl() {
	start_time_tc TC_imfilterctrl_tc
	
	account_create_fn "Utility12"
	imboxstats_fn "Utility1" > log_imboxstats.txt 
	msg_exists=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists=`echo $msg_exists | tr -d " "`
	echo "msg_exists" $msg_exists 
	echo "if header \"from\" contains \""$MAILFROM"@openwave.com\" {" > imfilter.txt
	echo "forward \"Utility1@openwave.com\";" >> imfilter.txt
	echo "}" >> imfilter.txt
	
	imfilterctrl set Utility12 openwave.com imfilter.txt
	imfilterctrl get Utility12 openwave.com > imfilter1.txt
	mail_send "Utility12" "small" "1"
	msg_msgimfilter=$(diff imfilter.txt imfilter1.txt)
	
	imboxstats_fn "Utility1" > log_imboxstats.txt 
	msg_exists_new=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
	msg_exists_new=`echo $msg_exists_new | tr -d " "`
	echo "msg_exists_new" $msg_exists_new
	total_count=$(($msg_exists+1))
	
	if [[ "$msg_msgimfilter" == "" && "$total_count" == "$msg_exists_new" ]]
	then
		prints "imfilterctrl set the forward rule" "TC_imfilterctrl" "2"
		prints "imfilterctrl is working fine " "TC_imfilterctrl" "2"
		Result="0"
	else
		prints "ERROR: imfilterctrl cant set the filter rule " "TC_imfilterctrl" "1"
		prints "ERROR: imfilterctrl is not working fine. Please check Manually." "TC_imfilterctrl" "1"
		Result="1"
	fi
	
	summary "UTILITIES:TC_imfilterctrl" $Result
	account_delete_fn "Utility12"
}
#testcase 169
function TC_imboxtest(){
	start_time_tc TC_imboxtest_tc
	
	account_create_fn "Utility13"
	imboxtest_utility "Utility13"
	
	summary "UTILITIES:TC_imboxtest" $Result
	account_delete_fn "Utility13"
}
#testcase 170
function TC_imcheckfq(){
	start_time_tc TC_imcheckfq_tc
	
	account_create_fn "Utility14"
	imcheckfq_utility "Utility14"
	
	summary "UTILITIES:TC_imcheckfq" $Result
	account_delete_fn "Utility14"
}
# testcase 171
function TC_imboxmaint() {
 
	#start_time_tc TC_imboxmaint_tc
	
	set_config_keys "/*/common/mailFolderQuotaEnabled" "true" "1"
	maint_cn=$(cat $INTERMAIL/config/config.db | grep clusterName|grep -v imboxmaint | cut -d "/" -f2 | cut -d "-" -f2) 
  set_config_keys "/*/imboxmaint/clusterName" "$maint_cn" 
	account_create_fn "Utility15"
	imcheckfq_utility "Utility15"
	#imdbcontrol SetAccountCos Utility15 openwave.com mailfolderquota '/ all,AgeSeconds,1'
	./sm.pl -u Utility15 ./1K
	#sleep 60
	
	quotaset_check="0"
	quotaset_check=$(cat log_imcheckfq.txt | egrep -i "AgeSeconds" | wc -l)
	quotaset_check=`echo $quotaset_check | tr -d " "`
	if [ "$quotaset_check" == "1" ]
	then
		imboxstats_fn "Utility15"
		msg_exists=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
		msg_exists=`echo $msg_exists | tr -d " "`	
		
		prints  "Now Running Maintenance on this mailbox, please wait..."
		#imboxmaint_fn is a defiend function ,check functin imboxmaint_fn
		imboxmaint_fn Utility15@openwave.com > log_boxmaint.txt
		check_maint=$(cat log_boxmaint.txt | grep -i "maintenance done for mailbox" | wc -l)
		check_maint=`echo $check_maint | tr -d " "`	
		
		imboxstats_fn "Utility15"
		msg_exists_new=$(cat log_imboxstats.txt | grep -i "Total Messages Stored" | cut -d ":" -f2)
		msg_exists_new=`echo $msg_exists_new | tr -d " "`
		prints  "After running maintenance, there are "$msg_exists_new" Messages in the mailbox"
		if [[ "$msg_exists_new" == "0" && "$check_maint" == "1" ]]
		then
			prints  "imboxmaint utility for Utility15 is working fine." "TC_imboxmaint" "2"
			Result="0"	
		else
			prints  "ERROR: imboxmaint utility for Utility15 is not working fine. Please check Manually." "TC_imboxmaint" "1"
			Result="1"
		fi
	else
		prints  "ERROR: FolderQuota is not set properly for Utility15." "TC_imboxmaint" "1"
	fi
	#read -n 1 -p "Press any key to continue..."
		
	summary "UTILITIES:TC_imboxmaint" $Result	
	set_config_keys "/*/mss/mailFolderQuotaEnabled" "false" "1"
  imconfcontrol -install -key "/*/imboxmaint/clusterName" &> config_output.txt
	account_delete_fn "Utility15"
}

#Test Cases for Sepcial delete feature
#testcase 187
function TC_SpecialDelete_POP(){
	start_time_tc TC_SpecialDelete_POP_tc
	
	special_delete_case_pop "$user16"
	
	summary "SPECIAL DELETE:TC_SpecialDelete_POP" $Result
	immsgdelete_utility "$user16" "-all"
}
#testcase 188
function TC_SpecialDelete_IMAP(){
	
	start_time_tc TC_SpecialDelete_IMAP_tc
	
	special_delete_case_imap "$user16"
	summary "SPECIAL DELETE:TC_SpecialDelete_IMAP" $Result
	immsgdelete_utility "$user16" "-all"
}

#logging enhancement testcases
#imap
function TC_logging_enhancement_imap (){
	start_time_tc "TC_logging_enhancement_imap"
	fhc=`grep -i  fromhost  $INTERMAIL/log/imapserv.log|wc -l`
	fpc=`grep -i  fromport  $INTERMAIL/log/imapserv.log|wc -l`
  if [ $fhc -eq $fpc ];then
  	 prints "logging enhancement for imap is success" "TC_logging_enhancement_imap"
  	 Result=0 
  else
  	 prints "logging enhancement for imap is failed" "TC_logging_enhancement_imap"
  	 Result=1
  fi
  summary "TC_logging_enhancement_imap" $Result
} 

#pop
function TC_logging_enhancement_pop (){
	start_time_tc "TC_logging_enhancement_pop"
	fhc=`grep -i  fromhost  $INTERMAIL/log/popserv.log|wc -l`
	fpc=`grep -i  fromport  $INTERMAIL/log/popserv.log|wc -l`
  if [ $fhc -eq $fpc ];then
  	 prints "logging enhancement for pop is success" "TC_logging_enhancement_pop"
  	 Result=0 
  else
  	 prints "logging enhancement for pop is failed" "TC_logging_enhancement_pop"
  	 Result=1
  fi
  summary "TC_logging_enhancement_pop" $Result
} 

#mta
function TC_logging_enhancement_smtp (){
	start_time_tc "TC_logging_enhancement_smtp"
	fhc=`grep -i  fromhost  $INTERMAIL/log/mta.log|wc -l`
	fpc=`grep -i  fromport  $INTERMAIL/log/mta.log|wc -l`
  if [ $fhc -eq $fpc ];then
  	 prints "logging enhancement for smtp is success" "TC_logging_enhancement_smtp"
  	 Result=0 
  else
  	 prints "logging enhancement for smtp is failed" "TC_logging_enhancement_smtp"
  	 Result=1
  fi
  summary "TC_logging_enhancement_smtp" $Result
} 

#LDAP Test Cases
 
function ldap_add_test() {
	              start_time_tc ldap_add_test_tc
		            DIRHost=$(cat $INTERMAIL/config/config.db | grep -i dirserv_run  | grep -i on | cut -d "/" -f2)						 
					      DIRPort=$(cat $INTERMAIL/config/config.db | grep -i ldapPort | grep -v cache | grep -v pabd |cut -d "[" -f2 | cut -d "]" -f1)	
							  prints " Directory Host = $DIRHost" "ldap_add_test" 
							  prints " Directory Port = $DIRPort" "ldap_add_test" 
						    user=ldaptest1
							  mailboxid="1"$(date +%S%k%M%S)
							  mailboxid=`echo $mailboxid | tr -d " "`
    						echo "dn: mail=$user@openwave.com,dc=openwave,dc=com" > add.ldif
							  echo "objectclass: top" >> add.ldif
							  echo "objectclass: person" >> add.ldif
							  echo "objectclass: mailuser" >> add.ldif
							  echo "objectclass: mailuserprefs" >> add.ldif
							  echo "mailpassword: $user" >> add.ldif
							  echo "mailpasswordtype: C" >> add.ldif
							  echo "mailboxstatus: A" >> add.ldif
							  echo "maillogin: $user" >> add.ldif
							  echo "mail: $user@openwave.com" >> add.ldif
							  echo "mailmessagestore: $DIRHost" >> add.ldif
                echo "mailautoreplyhost: $DIRHost" >> add.ldif
                echo "mailboxid: $mailboxid" >> add.ldif
							  echo "cn: $user@openwave.com" >> add.ldif
 							  echo "sn: $user@openwave.com" >> add.ldif
							  echo "adminpolicydn: cn=default,cn=admin root" >> add.ldif
							  prints " Adding account $user@openwave.com ..... " "ldap_add_test" 
							  ldapadd -D cn=root -w secret -p $DIRPort -f add.ldif > add_result.txt
							  code=$(cat add_result.txt | grep -i " return code" | cut -d " " -f7 )
							  code=`echo $code | tr -d " "`
							  if [ "$code" == "0" ]
							  then
							      #echo						
										prints " Account created successfully ...." "ldap_add_test" "2"
							  else
                    #echo						
                    prints " ERROR : Account cannot be created ...." "ldap_add_test" "1"
							  fi
		  
							 imdbcontrol la | grep  -i $user | grep @ >add_result.txt
							 added=$(cat add_result.txt|  cut -d ":" -f2 | cut -d "@" -f1 )
							 added=`echo $added | tr -d " "`
							 if [ "$added" == "$user" ]
							 then
							     prints " LDAPADD is working correctly " "ldap_add_test" "2"
								   summary "LDAPADD" 0
                                 
							 else
               		 prints " ERROR : LDAPADD is not working correctly " "ldap_add_test" "1"
								   summary "LDAPADD" 1
                   #echo
               fi								 
prints "Testing of ldapadd utility is completed" "ldap_add_test" 
							 
}
# testcase 140
function ldap_search_utilty() {
                              start_time_tc ldap_search_utilty_tc
		         
							  prints " Searching account $user12@openwave.com ..... " "ldap_search_utilty" 
							  ldapsearch -D cn=root -w secret -p $DIRPort "mail=$user12*" > search_result.txt
							  found=$(cat search_result.txt | grep -i "mail" | cut -d "," -f1 | cut -d "=" -f2 |head -1|cut -d "@" -f1 )
							  found=`echo $found | tr -d " "`
							  if [ "$found" == "$user12" ]
							  then
							      #echo						
                                  prints " Account found ...." "ldap_search_utilty" "2"
								  prints " Ldap search is working properly " "ldap_search_utilty" "2"
								  summary "LDAPSEARCH" 0
								  #echo
							  else
                                  #echo						
                                  prints " ERROR : Account is not found ...." "ldap_search_utilty" "1"
								  prints " ERROR : Ldap search is not working properly " "ldap_search_utilty" "1"
								  summary "LDAPSEARCH" 1
								  #echo
							  fi
                             prints "Testing of ldapsearch utility is completed" "ldap_search_utilty" 
                             #echo
							 
}
# testcase 141
function ldap_modify_utility() {
                              start_time_tc ldap_modify_utility_tc
		                      echo "dn: mail=$user12@openwave.com,dc=openwave,dc=com" > modify.ldif
                              echo "changetype: modify" >> modify.ldif
                              echo "replace: mailpassword" >> modify.ldif
                              echo "mailpassword: abcd" >> modify.ldif
     						  prints " Modifying accoun $user12@openwave.com ..... " "ldap_modify_utility" "debug"
							  ldapmodify -D cn=root -w secret -p $DIRPort -f modify.ldif >modify_result.txt 
							  result=$(cat modify_result.txt | grep -i " return code" | cut -d " " -f6 )
							  result=`echo $result | tr -d " "`
							  if [ "$result" == "0" ]
							  then
							      #echo						
                                  prints " Account maillpassword modified  successfully ...." "ldap_modify_utility" "2"
							  else
                                  #echo						
                                  prints " ERROR : Account mailpassword cannot be modified  ...." "ldap_modify_utility" "1"
							  fi
							 ldapsearch -D cn=root -w secret -p $DIRPort "mail=$user12*" > modify_result1.txt
							 modified=$(cat modify_result1.txt| grep -i mailpassword| cut -d "=" -f2 |tail -1  )
							 modified=`echo $modified | tr -d " "`
							 if [ "$modified" == "abcd" ]
							 then
							     prints " LDAPMODIFY is working correctly " "ldap_modify_utility" "2"
								  summary "LDAPMODIFY" 0
                                 #echo
							 else
               					 prints " ERROR : LDAPMODIFY is not working correctly " "ldap_modify_utility" "1"
								 summary "LDAPMODIFY" 1
                                 #echo
                             fi								 
                            prints "Testing of ldapmodify utility is completed" "ldap_modify_utility"
							#echo
                            
}
# testcase 142
function ldap_delete_utility() {
                              start_time_tc ldap_delete_utility_tc
							  
		                      echo "mail=$user@openwave.com,dc=openwave,dc=com"  > del.ldif
							  prints " Deleting account $user@openwave.com ..... " "ldap_delete_utility" 
  
							  ldapdelete -D cn=root -w secret -p $DIRPort -f del.ldif 
  
							  imdbcontrol la |grep @ |grep -i $user > delete_result.txt
							  deleted=$(cat delete_result.txt | wc -l  )
							  deleted=`echo $deleted | tr -d " "`
							  if [ "$deleted" == "0" ]
							  then
							      #echo						
                                  prints " Account deleted ...." "ldap_delete_utility" "2"
								  #echo
								  prints " Ldap delete is working properly " "ldap_delete_utility" "2"
								  summary "LDAPDELETE" 0
							  else
                                  #echo						
                                  prints " Account is not deleted ...." "ldap_delete_utility" "1"
								  #echo
								  prints " Ldap delete is not working " "ldap_delete_utility" "1"
								  summary "LDAPDELETE" 1
							  fi
	
                             prints "Testing of ldapdelete utility is completed" "ldap_delete_utility" 
							 #echo
							 
}
#Test cases for invalid keys
#testcase 143
function invalid_keyvalue_msslog_imap() {
								start_time_tc invalid_keyvalue_msslog_imap_tc
								prints "################################################################" "invalid_keyvalue_msslog_imap" "debug"
								prints "| Check for [keepalive=1 Invalid key value] in mss log for IMAP|" "invalid_keyvalue_msslog_imap" "debug"
								prints "################################################################" "invalid_keyvalue_msslog_imap" "debug"
								#imconfcontrol -install -key "/*/mss/autoReplyExpireDays=3" &>> trash
								#imconfcontrol -install -key  "*/common/traceOutputLevel=keepalive=1" &>> trash
								#imconfcontrol -install -key  "/*/mss/bogus1=12333223" &>> trash
								#imconfcontrol -install -key  "/*/mss/bogus1=wwwqweeqe" &>> trash
								#imconfcontrol -install -key  "/*/mss/bogus3=312sdwqwewe" &>> trash
								#imconfcontrol -install -key  "/*/mss/bogus4=3423eweeqwewa" &>> trash
								
								#mail send to user1
							    #mail_send $user1 small 2
								#exec 3<>/dev/tcp/$MTAHost/$SMTPPort
								#echo -en "MAIL FROM:$MAILFROM\r\n" >&3
								#echo -en "RCPT TO:$user1\r\n" >&3
								#echo -en "DATA\r\n" >&3
								#echo -en "Subject: $SUBJECT\r\n\r\n" >&3
								#echo -en "$DATA\r\n" >&3
								#echo -en ".\r\n" >&3
								#echo -en "MAIL FROM:$MAILFROM\r\n" >&3
								#echo -en "RCPT TO:$user1\r\n" >&3
								#echo -en "DATA\r\n" >&3
								#echo -en "Subject: $SUBJECT\r\n\r\n" >&3
								#echo -en "$DATA\r\n" >&3
								#echo -en ".\r\n" >&3
								#echo -en "QUIT\r\n" >&3
								#cat <&3 > mail.txt
								#echo
								
								exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
								echo -en "a login $user1 $user1\r\n" >&3
								echo -en "a logout\r\n" >&3
								#echo "+++++++++++++++++++++++++"
								cat <&3 >> imap.txt
								#cat imap.txt
								#echo "+++++++++++++++++++++++++"
								
																					
								imconfcontrol -install -key "/*/mss/bogus1=12333240" &>> trash
								imconfcontrol -install -key "/*/mss/autoReplyExpireDays=20" &>> trash
								
								exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
								echo -en "a login $user1 $user1\r\n" >&3
								echo -en "a logout\r\n" >&3
								prints "+++++++++++++++++++++++++" "invalid_keyvalue_msslog_imap" "debug"
								cat <&3 >> imap.txt
								cat imap.txt >>debug.log
								prints "+++++++++++++++++++++++++" "invalid_keyvalue_msslog_imap" "debug"
							 
							    msg_count=$(cat $INTERMAIL/log/mss.log | grep "keepalive=1 Invalid key value" | wc -l)
															
								if [ "$msg_count" == "0" ]
								then
								
								
								prints "We are not able to see [keepalive=1 Invalid key value] in mss log for IMAP" "invalid_keyvalue_msslog_imap" "2"
								Result="0"
								else
								
								prints "We are able to see [keepalive=1 Invalid key value] in mss log for IMAP. Please check manually." "invalid_keyvalue_msslog_imap" "1"
								Result="1"
								
								fi 
								#end_time_tc invalid_keyvalue_msslog_imap_tc
								summary "To verify keepalive=1 Invalid key value in mss log for IMAP" $Result
								
}
# testcase 144
function invalid_keyvalue_msslog_pop() {
								start_time_tc invalid_keyvalue_msslog_pop_tc
								prints "################################################################" "invalid_keyvalue_msslog_pop" "debug"
								prints "| Check for [keepalive=1 Invalid key value] in mss log for POP|" "invalid_keyvalue_msslog_pop" "debug"
								prints "################################################################" "invalid_keyvalue_msslog_pop" "debug"
								#imconfcontrol -install -key "/*/mss/autoReplyExpireDays=3" &>> trash
								#imconfcontrol -install -key  "*/common/traceOutputLevel=keepalive=1" &>> trash
								#imconfcontrol -install -key  "/*/mss/bogus1=12333223" &>> trash
								#imconfcontrol -install -key  "/*/mss/bogus1=wwwqweeqe" &>> trash
								#imconfcontrol -install -key  "/*/mss/bogus3=312sdwqwewe" &>> trash
								#imconfcontrol -install -key  "/*/mss/bogus4=3423eweeqwewa" &>> trash
								
							    prints "Sending mail to $user1" "invalid_keyvalue_msslog_pop" 
								#mail_send $user1 small 2
								
								exec 3<>/dev/tcp/$POPHost/$POPPort
								echo -en "user $user1\r\n" >&3
								echo -en "pass $user1\r\n" >&3
								echo -en "quit\r\n" >&3
								
								#cat <&3 
								
								imconfcontrol -install -key "/*/mss/bogus1=12333230" &>> trash
								imconfcontrol -install -key "/*/mss/autoReplyExpireDays=10" &>> trash
									
								exec 3<>/dev/tcp/$POPHost/$POPPort
								echo -en "user $user1\r\n" >&3
								echo -en "pass $user1\r\n" >&3
								echo -en "quit\r\n" >&3
								prints "+++++++++++++++++++++++++" "invalid_keyvalue_msslog_pop" "debug"
								cat <&3 >>debug.log
								prints "+++++++++++++++++++++++++" "invalid_keyvalue_msslog_pop" "debug"
								echo
									
							    msg_count=$(cat $INTERMAIL/log/mss.log | grep "keepalive=1 Invalid key value" | wc -l)
								
							
								if [ "$msg_count" == "0" ]
								then
								
								
								prints "We are not able to see [keepalive=1 Invalid key value] in mss log for POP" "invalid_keyvalue_msslog_pop" "2"
								Result="0"
								else
								
								prints "We are able to see [keepalive=1 Invalid key value] in mss log for POP. Please check manually." "invalid_keyvalue_msslog_pop" "1"
								Result="1"
								
								fi
								#end_time_tc invalid_keyvalue_msslog_pop_tc
								summary "To verify keepalive=1 Invalid key value in mss log for POP" $Result
}
#Test cases to check large msg delivery
# testcase 145-150
function large_msg_delivery() {
        start_time_tc large_msg_delivery_tc
        immsgdelete_utility "$user20" "-all"
        imdbcontrol sac $user20 openwave.com mailquotamaxmsgkb 0
        imdbcontrol sac $user20 openwave.com mailquotatotkb 0
        ## Checking Large message delivery
        ### Testing delivery of 100Kb msg  
        prints "########################################" "large_msg_delivery" "debug"
        prints "|  VERIFING DELIVERY OF 100KB MESSAGE |" "large_msg_delivery" 
        prints "########################################" "large_msg_delivery" "debug"
        #echo	
        msg_100kb=`cat 100K`
        ## 100KB Message Delivery Starts
        #echo
        #prints "-------100KB Message Delivery Starts--------"
        #prints "Connecting to $MTAHost on Port $SMTPPort";
        #prints "Please wait ... "
        #echo
        prints "Sending a mail to $user20" "large_msg_delivery" 
        exec 3<>/dev/tcp/$MTAHost/$SMTPPort
        echo -en "MAIL FROM:$MAILFROM\r\n" >&3
        echo -en "RCPT TO:$user20\r\n" >&3
        echo -en "DATA\r\n" >&3
        echo -en "Subject: $SUBJECT\r\n\r\n" >&3
        echo -en "$msg_100kb\r\n" >&3
        echo -en ".\r\n" >&3
        echo -en "QUIT\r\n" >&3
        #echo
        imboxstats $user20@openwave.com > boxstats.txt
        msgs_user=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
        msgs_user=`echo $msgs_user | tr -d " "`
        msgs_stored=$(grep "Total Bytes Stored" boxstats.txt | cut -d ":" -f2)
        msgs_stored=`echo $msgs_stored | tr -d " "`
        msgs_size=`ls -l 100K | cut -d " " -f5`
        #prints "============================================"
	if [ "$msgs_user" == "1" ];then
            if [ $msgs_stored -gt $msgs_size ]
            then
                prints $msgs_user" Mails were delivered successfully." "large_msg_delivery" "2"
                summary "100KB message delivery" 0
            else 
                prints "Total Bytes Stored is $msgs_stored : which should be greater than $msgs_size" "large_msg_delivery" "1"
                summary "100KB message delivery" 1 
            fi
        else
        #echo
            prints "ERROR: "$msgs_user" Mails were delivered only." "large_msg_delivery" "1"
            prints "ERROR: Mails delivery failed. Please check this Manually." "large_msg_delivery" "1"
            summary "100KB message delivery" 1
        fi
        #echo
        prints "100KB Message Delivery Sessions Ends." "large_msg_delivery" 
        #echo						
        prints "Testing delivery of 100Kb msg is completed." "large_msg_delivery" 
        #echo
        start_time_tc large_msg_delivery_tc
        ### Testing delivery of 200Kb msg  
        prints "########################################" "large_msg_delivery" "debug"
        prints "|  VERIFING DELIVERY OF 200KB MESSAGE |" "large_msg_delivery" 
        prints "########################################" "large_msg_delivery" "debug"
        #echo	
        ## 200KB Message Delivery Starts
        prints "200KB Message Delivery Starts" "large_msg_delivery" 
        #echo "Connecting to $MTAHost on Port $SMTPPort";
        # echo "Please wait ... "
        prints "Sending a mail to $user20" "large_msg_delivery" 
        exec 3<>/dev/tcp/$MTAHost/$SMTPPort
        echo -en "MAIL FROM:$MAILFROM\r\n" >&3
        echo -en "RCPT TO:$user20\r\n" >&3
        echo -en "DATA\r\n" >&3
        echo -en "Subject: $SUBJECT\r\n\r\n" >&3
        echo -en "$msg_100kb\r\n" >&3
        echo -en "$msg_100kb\r\n" >&3
        echo -en ".\r\n" >&3
        echo -en "QUIT\r\n" >&3
        #echo
        imboxstats $user20@openwave.com > boxstats.txt
        msgs_user=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
        msgs_user=`echo $msgs_user | tr -d " "`
        msgs_stored=$(grep "Total Bytes Stored" boxstats.txt | cut -d ":" -f2)
        msgs_stored=`echo $msgs_stored | tr -d " "`
        let msgs_size=2*$msgs_size
        if [ "$msgs_user" == "2" ];then
            if [ $msgs_stored -gt $msgs_size ]
            then
                    prints $msgs_user" Mails were delivered successfully." "large_msg_delivery" "2"
                    summary "200KB message delivery" 0
            else
                    prints "Total Bytes Stored is $msgs_stored : which should be greater than $msgs_size" "large_msg_delivery" "1"
                    summary "200KB message delivery" 1
            fi
        else
                prints "ERROR: "$msgs_user" Mails were delivered only." "large_msg_delivery" "1"
                prints "ERROR: Mails delivery failed. Please check this Manually." "large_msg_delivery" "1"
                summary "200KB message delivery" 1
        fi
        #echo
        prints "200KB Message Delivery Sessions Ends" "large_msg_delivery" 
        #echo
        start_time_tc large_msg_delivery_tc
        ### Testing delivery of 1MB msg  
        prints "######################################" "large_msg_delivery" "debug"
        prints "|  VERIFING DELIVERY OF 1MB MESSAGE |" "large_msg_delivery" 
        prints "######################################" "large_msg_delivery" "debug"
        #echo	
        msg_1mb=`cat 1MB`
        ## 1MB Message Delivery Starts
        prints "1MB Message Delivery Starts" "large_msg_delivery" 
        #echo "Connecting to $MTAHost on Port $SMTPPort";
        #echo "Please wait ... "
        prints "Sending a mail to $user20" "large_msg_delivery"
        exec 3<>/dev/tcp/$MTAHost/$SMTPPort
        echo -en "MAIL FROM:$MAILFROM\r\n" >&3
        echo -en "RCPT TO:$user20\r\n" >&3
        echo -en "DATA\r\n" >&3
        echo -en "Subject: $SUBJECT\r\n\r\n" >&3
        echo -en "$msg_1mb\r\n" >&3
        echo -en ".\r\n" >&3
        echo -en "QUIT\r\n" >&3
        #echo
        imboxstats $user20@openwave.com > boxstats.txt
        msgs_user=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
        msgs_user=`echo $msgs_user | tr -d " "`
        msg_1mb_size=`ls -l 1MB | cut -d " " -f5`
        let msgs_size=${msg_1mb_size}+${msgs_stored}
        msgs_stored=$(grep "Total Bytes Stored" boxstats.txt | cut -d ":" -f2)
        msgs_stored=`echo $msgs_stored | tr -d " "`
        #echo "============================================"
        if [ "$msgs_user" == "3" ];then
            if [ $msgs_stored -gt $msgs_size ]
            then
                    prints $msgs_user" Mails were delivered successfully." "large_msg_delivery" "2"
                    summary "1MB message delivery" 0
            else
                    prints "Total Bytes Stored is $msgs_stored : which should be greater than $msgs_size" "large_msg_delivery" "1"
                    summary "1MB message delivery" 1
            fi
        else
                prints "ERROR: "$msgs_user" Mails were delivered only." "large_msg_delivery" "1"
                prints "ERROR: Mails delivery failed. Please check this Manually." "large_msg_delivery" "1"
                summary "1MB message delivery" 1
        fi
        prints "1MB Message Delivery Sessions Ends" "large_msg_delivery" 
        prints "Testing delivery of 1MB msg is completed" "large_msg_delivery" 
        start_time_tc large_msg_delivery_tc
        ### Testing delivery of 10MB msg  
        prints "#######################################" "large_msg_delivery" "debug"
        prints "|  VERIFING DELIVERY OF 10MB MESSAGE |" "large_msg_delivery" 
        prints "#######################################" "large_msg_delivery" "debug"
        #echo	
        msg_10mb=`cat 10MB`
        ## 10MB Message Delivery Starts
        prints "10MB Message Delivery Starts" "large_msg_delivery" 
        #prints "Connecting to $MTAHost on Port $SMTPPort";
        #prints "Please wait ... "
        prints "Sending a mail to $user20" "large_msg_delivery" 
        exec 3<>/dev/tcp/$MTAHost/$SMTPPort
        echo -en "MAIL FROM:$MAILFROM\r\n" >&3
        echo -en "RCPT TO:$user20\r\n" >&3
        echo -en "DATA\r\n" >&3
        echo -en "Subject: $SUBJECT\r\n\r\n" >&3
        echo -en "$msg_10mb\r\n" >&3
        echo -en ".\r\n" >&3
        echo -en "QUIT\r\n" >&3
				   
        imboxstats $user20@openwave.com > boxstats.txt
        msgs_user=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
        msgs_user=`echo $msgs_user | tr -d " "`
        msg_10mb_size=`ls -l 10MB | cut -d " " -f5`
        let msgs_size=${msg_10mb_size}+${msgs_stored}
        msgs_stored=$(grep "Total Bytes Stored" boxstats.txt | cut -d ":" -f2)
        msgs_stored=`echo $msgs_stored | tr -d " "`
        #prints "============================================"
        if [ "$msgs_user" == "4" ];then
            if [ $msgs_stored -gt $msgs_size ]
            then
                    prints $msgs_user" Mails were delivered successfully." "large_msg_delivery" "2"
                    summary "10MB message delivery" 0
            else
                    prints "Total Bytes Stored is $msgs_stored : which should be greater than $msgs_size" "large_msg_delivery" "1"
                    summary "10MB message delivery" 1
            fi
        else
                prints "ERROR: "$msgs_user" Mails were delivered only." "large_msg_delivery" "1"
                prints "ERROR: Mails delivery failed. Please check this Manually." "large_msg_delivery" "1"
                summary "10MB message delivery" 1
        fi
        #echo
        prints "10MB Message Delivery Sessions Ends" "large_msg_delivery"
        prints "Testing delivery of 10MB msg is completed" "large_msg_delivery"
        #echo
        start_time_tc large_msg_delivery_tc
        ## POP OPERATIONS TO RETRIEVE MESSAGES OF VARIOUS SIZE
        prints "===========================" "large_msg_delivery" "debug"
        prints " PERFORMING POP OPERATIONS " "large_msg_delivery" 
        prints "===========================" "large_msg_delivery" "debug"
        #echo
        #echo "Connecting to $POPHost on Port $POPPort";
        #echo "Please wait ... "
        #echo
        prints "Sending a mail to $user20" "large_msg_delivery" 
        exec 3<>/dev/tcp/$POPHost/$POPPort
        echo -en "user $user20\r\n" >&3
        echo -en "pass $user20\r\n" >&3
        echo -en "list\r\n" >&3
        echo -en "retr 1\r\n" >&3
        echo -en "retr 2\r\n" >&3
        echo -en "quit\r\n" >&3
        prints "+++++++++++++++++++++++++" "large_msg_delivery" "debug"
        cat <&3 >>temporary.txt
        prints "+++++++++++++++++++++++++" "large_msg_delivery" "debug"
        #echo
        ### Check for errors in pop logs
        cat $INTERMAIL/log/popserv.log| egrep -i "erro;|urgt;|fatl;" > pop_errors.txt
        err_count=$(cat $INTERMAIL/log/popserv.log| egrep -i "erro;|urgt;|fatl;" | wc -l)
        if [ "$err_count" -gt "0" ]	
        then
                prints "Error found in popserv.log. Please check debug.log" "large_msg_delivery" "1"
        else
                prints "No Error found in popserv.log." "large_msg_delivery" "2"
        fi
									
        prints "Errors logged in POP Logs:" "large_msg_delivery" "debug"
        prints "==========================" "large_msg_delivery" "debug"
        cat pop_errors.txt >> debug.log
        #echo
        prints "==========================" "large_msg_delivery" "debug"
        err=$(cat pop_errors.txt | wc -l)
        err=` echo $err | tr -d " "`
        if [ "$err" == "0" ]
        then
                prints " Retrieval large messages through POP is working fine " "large_msg_delivery" "2"
                summary "Retrieving large messages through POP" 0
        else
                prints " Retrieval large messages through POP is not working " "large_msg_delivery" "1"
                summary "Retrieving large messages through POP" 1 
        fi									
                prints "Testing retrieving of large messages through POP is completed" "large_msg_delivery" 
        #echo
									
        start_time_tc large_msg_delivery_tc
        ## IMAP OPERATIONS START FROM HERE
        prints "==========================" "large_msg_delivery" "debug"
        prints "PERFORMING IMAP OPERATIONS" "large_msg_delivery" 
        prints "==========================" "large_msg_delivery" "debug"
        #echo
        #echo "Connecting to $IMAPHost on Port $IMAPPort";
        #echo "Please wait ... "
        #echo
        prints "Sending a mail to $user20" "large_msg_delivery" 
        echo > temporary.txt
        exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
        echo -en "a login $user20 $user20\r\n" >&3
        echo -en "a fetch 1:2 rfc822\r\n" >&3	
        echo -en "a logout\r\n" >&3
        #echo "+++++++++++++++++++++++++" "large_msg_delivery" "debug"
        cat <&3 >>temporary.txt
        #echo "+++++++++++++++++++++++++" "large_msg_delivery" "debug"
        #echo
        ### Check for errors in the imap logs
        cat $INTERMAIL/log/imapserv.log| egrep -i "erro;|urgt;|fatl;" > imap_errors.txt
        err_count=$(cat $INTERMAIL/log/imapserv.log| egrep -i "erro;|urgt;|fatl;" | wc -l)
        if [ "$err_count" -gt "0" ]	
        then
                prints "Error found in imapserv.log. Please check debug.log" "large_msg_delivery" "1"
        else
                prints "No Error found in imapserv.log." "large_msg_delivery" "2"
        fi
									
        prints "Errors logged in IMAP Logs:" "large_msg_delivery" "debug"
        prints "==========================" "large_msg_delivery" "debug"
        cat imap_errors.txt >> debug.log
        #echo
        prints "==========================" "large_msg_delivery" "debug"
        prints "Testing retrieving of large messages through IMAP is completed" "large_msg_delivery" 
        #echo						
        err=$(cat imap_errors.txt | wc -l)
        err=` echo $err | tr -d " "`
        if [ "$err" == "0" ]
        then
                prints " Retrieval large messages through IMAP is working fine " "large_msg_delivery" "2"
                summary "Retrieving large messages through IMAP" 0
        else
                prints " Retrieval large messages through IMAP is not working " "large_msg_delivery" "1"
                summary "Retrieving large messages through IMAP" 1 
        fi		
							
}
#Scenario base Test cases 
#testcase 152
function expunge_cache_inconsistence() {
								start_time_tc expunge_cache_inconsistence_tc
								prints "##########################################################" "expunge_cache_inconsistence" "debug"
								prints "| Verify Expunge of message makes imap cache inconsistant|" "expunge_cache_inconsistence" "debug"
								prints "##########################################################" "expunge_cache_inconsistence" "debug"
								#echo
								#mail send to user8
								mail_send $user8 small 2
							    								
								echo > imap.txt
								exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
								echo -en "a login $user8 $user8\r\n" >&3
								echo -en "a select INBOX\r\n" >&3
								echo -en "a store 1 +flags (\Deleted)\r\n" >&3
								echo -en "a expunge\r\n" >&3
								echo -en "a logout\r\n" >&3
								prints "+++++++++++++++++++++++++" "expunge_cache_inconsistence" "debug"
								cat <&3 >> imap.txt
								cat imap.txt >>debug.log
								prints "+++++++++++++++++++++++++" "expunge_cache_inconsistence" "debug"
								
								msg_count1=$(cat $INTERMAIL/log/imapserv.trace | grep "expungeMsgCache" | wc -l)
								 
							  msg_count=$(cat $INTERMAIL/log/imapserv.trace | grep "unknown message" | wc -l)
								#[[ "$check_clustername_count" == "1" && "$check_setup_type" == "true" ]]
								
								if [[ "$msg_count" == "1" && "$msg_count1" != "0" ]]
								then
								
								
								prints " Expunge of message makes imap cache inconsistent. Please check manually." "expunge_cache_inconsistence" "1"
								Result="1"
								else
								
								prints " Expunge of message does not make imap cache inconsistent." "expunge_cache_inconsistence" "2"
								Result="0"
								
								fi 
								#end_time_tc expunge_cache_inconsistence_tc
								summary "Expunge of message makes imap cache inconsistent" $Result
}
#testcase 151
function no_flag_msg() {
                 start_time_tc no_flag_msg_tc
                 prints "VERIFICATION THAT NO FLAGS ARE SET IN SECOND SESSION" "no_flag_msg" 
    						 imboxstats $user4@openwave.com > boxstats_Sanity155.txt
				         msgs=$(grep "Total Messages Stored"  boxstats_Sanity155.txt | cut -d ":" -f2)
				         msgs=`echo $msgs | tr -d " "`
				         msgs=$(($msgs+1))
							   prints "Sending a mail to $user2 and $user4" "no_flag_msg" 
    					   exec 3<>/dev/tcp/$MTAHost/$SMTPPort
							   echo -en "MAIL FROM:$user2\r\n" >&3
							   echo -en "RCPT TO:$user4\r\n" >&3
							   echo -en "DATA\r\n" >&3
							   echo -en "Subject: $SUBJECT\r\n\r\n" >&3
							   echo -en "$DATA\r\n" >&3
							   echo -en ".\r\n" >&3
							   echo -en "QUIT\r\n" >&3
							   imboxstats $user4@openwave.com > boxstats_Sanity1.txt
				         msgs1=$(grep "Total Messages Stored"  boxstats_Sanity1.txt | cut -d ":" -f2)
				         msgs1=`echo $msgs1 | tr -d " "`
				         if [ "$msgs1" == "$msgs" ]
				         then
				             prints " Mail delivered " "no_flag_msg" "2"
							   else
							       prints " ERROR : Mail is not delivered " "no_flag_msg" "1"
								     summary "RECENT flag is not set in second session" 1
								     return 0
                 fi
							   
        					## CHECKING FLAGS THRUGH IMAP 
							prints "Checking flag through IMAP" "no_flag_msg" 
							echo > temporary.txt
     						exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							echo -en "a login $user4 $user4\r\n" >&3
							echo -en "a select INBOX\r\n" >&3
							echo -en "a logout\r\n" >&3
							cat <&3 >> temporary.txt
    						recent=$(cat temporary.txt |grep -i "recent" |cut -d " " -f2)
                            recent=`echo $recent | tr -d " "`
							if [ "$recent" == "1" ]
							then
							   	prints " Flag is Recent ..." "no_flag_msg" "2"
							else
							    prints " ERROR : Flag is not Recent ..." "no_flag_msg" "1"
							fi	
						  prints "Checking flags through IMAP" "no_flag_msg" 
							echo > temporary1.txt
							exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							echo -en "a login $user4 $user4\r\n" >&3
							echo -en "a select INBOX\r\n" >&3
    						echo -en "a logout\r\n" >&3
							cat <&3 >> temporary1.txt
							
							recent=$(cat temporary.txt |grep -i "recent" |cut -d " " -f2)
                            recent=`echo $recent | tr -d " "`
							if [ "$recent" == "0" ]
							then
								prints " ERROR : Flag is Recent ..." "no_flag_msg" "1"
								prints " ERROR : Utility is not working " "no_flag_msg" "1"
								summary "RECENT flag is not set in second session" 1
							else
     							prints " Flag is not Recent ..." "no_flag_msg" "2"
								prints " Utility is working fine " "no_flag_msg" "2"
								summary "RECENT flag is not set in second session" 0
							fi
							### Check for errors in the imap logs
							cat $INTERMAIL/log/imapserv.log| egrep -i "erro;|urgt;|fatl;" > imap_errors.txt
							err_count=$(cat $INTERMAIL/log/imapserv.log| egrep -i "erro;|urgt;|fatl;" | wc -l)
							if [ "$err_count" -gt "0" ]	
							then
							prints "Error found in imapserv.log. Please check debug.log" "no_flag_msg" "1"
							else
							prints "No Error found in imapserv.log." "no_flag_msg" "2"
							fi
							prints "Errors logged in IMAP Logs:" "no_flag_msg" "debug"
							prints "==========================" "no_flag_msg" "debug"
							cat imap_errors.txt >> debug.log
							prints "==========================" "no_flag_msg" "debug"
							
              prints "Testing that no flags are set for messages when checked through imap in second consecutive session utility is completed" "no_flag_msg" 
}
#testcase 158
function stored_command_before_login () {
start_time_tc
				prints "Store command not available in Non-Authenticated state " "stored_command_before_login" "debug"
							exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							echo -en "store 1:* FLAGS (\Seen)\r\n" >&3
							echo -en "a logout\r\n" >&3
							prints "+++++++++++++++++++++++++" "stored_command_before_login" "debug"
							cat <&3 > mail.txt
							prints "+++++++++++++++++++++++++" "stored_command_before_login" "debug"
							
							msg=$(cat mail.txt | grep "BAD Unrecognized command, please login" | wc -l)
							if [ "$msg" == "1" ]
									then										
										prints "Giving proper error" "stored_command_before_login" "2"
										Result="0"
									else										
										prints "ERROR:Not giving proper error message. Please check manually." "stored_command_before_login" "1"										
										Result="1"
				fi
				summary "Store command not available in Non-Authenticated state" $Result
}
#testcase 153 -156
function imap_uid_check_scenario() {
 start_time_tc
							prints "PERFORMING IMAP OPERATIONS" "imap_check" "debug"
							#echo
							prints "Connecting to $IMAPHost on Port $IMAPPort" "imap_check" "debug"
							#echo "Please wait ... "
							#echo
							
              echo > check.txt
							exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							echo -en "a login $user1 $user1\r\n" >&3
							echo -en "a select INBOX\r\n" >&3
							echo -en "a fetch 2 rfc822\r\n" >&3
							echo -en "a fetch 2:4 uid\r\n" >&3
							echo -en "a fetch 2 envelope\r\n" >&3
							echo -en "a logout\r\n" >&3
							prints "+++++++++++++++++++++++++" "imap_check" "debug"
							cat <&3 >> check.txt
							echo "############################################"
							cat check.txt
							echo "############################################"
							prints "+++++++++++++++++++++++++" "imap_check" "debug"
							#echo
              first=$(cat check.txt | grep "* 2 FETCH" | grep -i "UID" | cut -d " " -f5) 
							first=${first:0:4}
              prints " first uid == "$first "imap_check" 
							
							second=$(cat check.txt | grep "* 3 FETCH" | grep -i "UID" | cut -d " " -f5)
              second=${second:0:4}							
							prints " second uid == "$second "imap_check" 
							third=$(cat check.txt | grep "* 4 FETCH" | grep -i "UID" | cut -d " " -f5)
              third=${third:0:4}							
							prints " third uid == "$third "imap_check" 
							
							if [ "$first" == "1001" ] && [ "$second" == "1002" ] && [ "$third" == "1003" ]
							then
							   prints " UIDs are correct " "imap_check" "2"
							   summary "UID in IMAP is correct and in proper sequence" 0
							else
							   prints " ERROR : UIDs are not correct " "imap_check" "1"
							   summary "UID in IMAP is correct and in proper sequence" 1
							fi
							
							from=$(cat check.txt | grep "From:" | cut -d "<" -f2| cut -d ">" -f1 )
							from=` echo $from | tr -d " "`
							prints " from : "$from "imap_check" "debug"
							sub=$(cat check.txt | grep "Subject:" | cut -d " " -f2 )
							prints " subject : "$sub "imap_check" "debug"
							sub=` echo $sub | tr -d " "`
							to=$(cat check.txt | grep -i "for " | cut -d "<" -f2| cut -d ">" -f1|head -1)
							to=` echo $to | tr -d " "`
							prints " to: "$to "imap_check" "debug"
							
							if [ "$from" == "$MAILFROM@openwave.com" ]
							then
							    prints " From field is correct " "imap_check" 
								summary "From field in IMAP is correct" 0
							else
							    prints " Error: From field is not correct " "imap_check" "1"
								summary "From field in IMAP is correct" 1 
							fi
												
							if [ "$sub" == "Sanity" ]
							then
							    prints " Subject field is correct " "imap_check" 
								summary "Subject field in IMAP is correct" 0
							else
							    prints " Error: Subject field is not correct " "imap_check" "1"
								summary "Subject field in IMAP is correct" 1
							fi
							
							if [ "$to" == "$user1@openwave.com" ]
							then
							    prints " To field is correct " "imap_check" 
								summary "TO field in IMAP is correct" 0
							else
							    prints " Error: To field is not correct " "imap_check" "1"
								summary "TO field in IMAP is correct" 1
							fi							
							### Check for errors in the imap logs
							cat $INTERMAIL/log/imapserv.log| egrep -i "erro;|urgt;|fatl;" > imap_errors.txt
							error_count=$(cat $INTERMAIL/log/imapserv.log | egrep -i "erro;|urgt;|fatl;" | wc -l )
							if [ "$error_count" > "0" ]
							then					
							prints "Found failure logs in imapserv.log. Please check debug.log" "imap_check" "1"					
							else						
							prints "Did not Found failure logs in imapserv.log." "imap_check" "2"						
							fi
							
							prints "Errors logged in IMAP Logs:" "imap_check" "debug"
							prints "==========================" "imap_check" "debug"
							cat imap_errors.txt >> debug.log
							prints "==========================" "imap_check" "debug"
}
#Test case for Mode M
 
function account_mode_M() {
								start_time_tc account_mode_M_tc
								prints " Check for account mode M " "account_mode_M" "debug"								
								mail_send $user18 small 1							
							 	imdbcontrol SetAccountStatus $user18 openwave.com M 													
							msg_sh=$(imdbcontrol gaf $user18 openwave.com | grep "Status" | cut -d ":" -f2| grep "M" | wc -l)										
								if [ "$msg_sh" == "1" ]
								then									
									prints "Mode M account for a user is working fine" "setaccount_status" "2"
									Result="0"
								else
									prints "ERROR:Mode M account for a user is not working fine" "setaccount_status" "1"								
									prints "ERROR: Please check Manually." "setaccount_status" "1"
									Result="1"
								fi						
								summary "Mode M account for a user" $Result
								imdbcontrol SetAccountStatus $user18 openwave.com A >> debug.log								
								msg_sh=$(imdbcontrol gaf $user18 openwave.com | grep "Status" | cut -d ":" -f2| grep "A" | wc -l)
										
								if [ "$msg_sh" == "1" ]
								then
									prints "Mode is reset to A" "setaccount_status" "2"
								else									
									prints "ERROR:Mode is not reset to A" "setaccount_status" "1"									
								fi
							
}
#ITS related Test cases

function ITS_1319590() {
                start_time_tc ITS_1319590_tc
                prints "VERIFY IMMSGDELETE UTILITY " "ITS_1319590" 
                imboxstats $user2@openwave.com > boxstats.txt
				        msgs_user=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				        msgs_user=`echo $msgs_user | tr -d " "`
								
								if [ $msgs_user -gt 0 ]
								then
								  immsgdelete $user2@openwave.com -all
									imboxstats $user2@openwave.com > boxstats.txt
				          msgs_user1=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				          msgs_user1=`echo $msgs_user1 | tr -d " "`
									
									if [ "$msgs_user1" == "0" ]
									then
									    prints " Mail box emptied " "ITS_1319590" "2"
											prints " immsgdelete utility is working fine " "ITS_1319590" "2"
									else
									    prints " ERROR : Mail box is not emptied " "ITS_1319590" "1"
											prints " ERROR : immsgdelete utility is not working  " "ITS_1319590" "1"
									fi
								fi
								
                 echo > mail.txt
							   exec 3<>/dev/tcp/$MTAHost/$SMTPPort
							   echo -en "MAIL FROM:$MAILFROM\r\n" >&3
							   echo -en "RCPT TO:$user2\r\n" >&3
                 echo -en "DATA\r\n" >&3
							   echo -en "Subject: $SUBJECT\r\n\r\n" >&3
							   echo -en "$DATA\r\n" >&3
							   echo -en ".\r\n" >&3
							   echo -en "QUIT\r\n" >&3
							   cat <&3 >> mail.txt
								 imboxstats $user2@openwave.com > boxstats.txt
				         msgs_user=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				         msgs_user=`echo $msgs_user | tr -d " "`
				         if [ $msgs_user -gt 0 ]
				         then
					           prints " Mail is delivered successfully" "ITS_1319590" 
									   msgid=$(grep "Message received:" mail.txt| cut -d ":" -f2 | sed -e 's/^\s*//' -e 's/\s*$//' | tail -1 | cut -d "[" -f1) 
							       msgid=` echo $msgid | tr -d " "`
									   immsgdelete $user2@openwave.com $msgid > result.txt									
									   failed=$(cat result.txt | grep -i "failed" | wc -l)
									   failed=`echo $failed | tr -d " " `									
										if [ "$failed" == "0" ]
									  then
									    prints " Mail deleted " "ITS_1319590" "2"
											prints " immsgdelete utility for single message is working fine " "ITS_1319590" "2"
											summary "Immsgdelete for single message" 0
										else
									    prints " Mail not deleted " "ITS_1319590" "1"
											prints " immsgdelete utility for single message is not working  " "ITS_1319590" "1"
											summary "Immsgdelete for single message" 1 "ITS-1319590"
										fi
																		
							   else
								    prints " Mail cannot be delivered " "ITS_1319590" "debug"
										summary "Immsgdelete for single message" 1
                 fi							  
                 prints "Testing of immsgdelete utility is completed" "ITS_1319590" 
}
   
function ITS_1329310() {
                start_time_tc ITS_1329310_tc
								echo "From: $MAILFROM@openwave.com "  > message.txt 
							  echo "To: All" >> message.txt
								echo "Subject: Test mail" >> message.txt
							  echo >> message.txt
							  echo "This is a test mail ..."  >> message.txt
								msg=`cat message.txt`
								prints "Sending mail to $user4" "ITS_1329310" 
								> $INTERMAIL/log/mta.log
				        exec 3<>/dev/tcp/$MTAHost/$SMTPPort
				        echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				        echo -en "RCPT TO:$user4\r\n" >&3
				        echo -en "DATA\r\n" >&3
				        echo -en "$msg\r\n" >&3
				        echo -en ".\r\n" >&3
								echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				        echo -en "RCPT TO:$user4\r\n" >&3
				        echo -en "DATA\r\n" >&3
				        echo -en "$msg\r\n" >&3
				        echo -en ".\r\n" >&3
								echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				        echo -en "RCPT TO:$user4\r\n" >&3
				        echo -en "DATA\r\n" >&3
				        echo -en "$msg\r\n" >&3
				        echo -en ".\r\n" >&3
				        echo -en "QUIT\r\n" >&3
				        exec 3>&- 
				        cat $INTERMAIL/log/mta.log
				        imboxstats $user4@openwave.com > boxstats.txt
				        echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
				        cat  boxstats.txt
				        msgs_user=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				        msgs_user=`echo $msgs_user | tr -d " "`
								if [ $msgs_user -gt 0 ]
								then
								   ##CASE 1 : SAME MAILBOX WITH INVALID TO: HEADER ###
									 prints "CASE 1: SAME MAILBOX WITH INVALID TO: HEADER " "ITS_1329310" 
							     prints "PERFORMING IMAP FETCH ENVELOPE" "ITS_1329310" 
									 prints "Connecting to imap" "ITS_1329310" 
                   echo > temporary.txt
							     exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							     echo -en "a login $user4 $user4\r\n" >&3
							     echo -en "a select INBOX\r\n" >&3
									 echo -en "a fetch 1:* envelope\r\n" >&3
									 echo -en "a logout\r\n" >&3
									 cat <&3 >>temporary.txt
									 cat temporary.txt >> debug.log
									 invalid_field=$(cat temporary.txt | grep -i "()" | wc -l)
									 invalid_field=`echo $invalid_field | tr -d " " `
									 if [ $invalid_field -gt 0 ]
									 then
									   prints " Invalid header field found in fetch envelope ""ITS_1329310" "1"
										 prints " Scenario 1 is not working fine " "ITS_1329310" "1"
                     summary "FetchEnvelope with invalid TO: header" 1 "ITS-1329310 "									 
									 else
									   prints " Invalid header field not found in fetch envelope " "ITS_1329310" "2"
										 prints " Scenario 1 is working fine " "ITS_1329310" "2"
                     summary "FetchEnvelope with invalid TO: header" 0										 
									 fi								
									 ## CASE 2 : FOR CUSTOM FOLDER ###
									 prints "CASE 2 : FOR CUSTOM FOLDER " "ITS_1329310" 									 
							     prints "PERFORMING IMAP FETCH ENVELOPE" "ITS_1329310" 
                   echo > temporary.txt
							     exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							     echo -en "a login $user4 $user4\r\n" >&3
									 echo -en "a create NEWFOLDER\r\n" >&3
							     echo -en "a select INBOX\r\n" >&3
									 echo -en "a copy 1:* NEWFOLDER\r\n" >&3
									 echo -en "a select NEWFOLDER\r\n" >&3
									 echo -en "a fetch 1:* envelope\r\n" >&3
									 echo -en "a logout\r\n" >&3
									 cat <&3 >>temporary.txt
									 cat temporary.txt >> debug.log
									 invalid_field=$(cat temporary.txt | grep -i "()" | wc -l)
									 invalid_field=`echo $invalid_field | tr -d " " `
									 if [ $invalid_field -gt 0 ]
									 then
									     prints "Invalid header field found in fetch envelope " "ITS_1329310" "1"
											 prints "Scenario 2 is not working fine " "ITS_1329310" "1"
                       summary "FetchEnvelope for custom folder" 1 "ITS-1329310 "										 
									 else
									     prints " Invalid header field not found in fetch envelope " "ITS_1329310" "2"
											 prints " Scenario 2 is working fine " "ITS_1329310" "2"
											 summary "FetchEnvelope for custom folder" 0	
									 fi
								 
									 ## CASE 3 : FOR VARIOUS INVALID/VALID COMBINATION OF TO HEADER ###
									 prints "CASE 3 :  FOR VARIOUS INVALID/VALID COMBINATION OF TO HEADER " "ITS_1329310" 
								
									 echo "From: $MAILFROM@openwave.com "  > message.txt 
							     echo "To: $user4@openwave.com; anyuser " >> message.txt
								   echo "Subject: Test mail" >> message.txt
							     echo >> message.txt
							     echo "This is a test mail ..."  >> message.txt									 
									 echo "From: $MAILFROM@openwave.com "  > message1.txt 
							     echo "To: all; anyuser " >> message1.txt
								   echo "Subject: Test mail" >> message1.txt
							     echo >> message1.txt
							     echo "This is a test mail ..."  >> message1.txt
									 
									 msg=`cat message.txt`
									 msg1=`cat message1.txt`
									 prints "Sending mail to $user4" "ITS_1329310" 
				           exec 3<>/dev/tcp/$MTAHost/$SMTPPort
				           echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				           echo -en "RCPT TO:$user4\r\n" >&3
				           echo -en "DATA\r\n" >&3
				           echo -en "$msg\r\n" >&3
				           echo -en ".\r\n" >&3
								   echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				           echo -en "RCPT TO:$user4\r\n" >&3
				           echo -en "DATA\r\n" >&3
				           echo -en "$msg1\r\n" >&3
				           echo -en ".\r\n" >&3
								   echo -en "QUIT\r\n" >&3
				                    									 
									 imboxstats $user4@openwave.com > boxstats.txt
				           msgs_user1=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				           msgs_user1=`echo $msgs_user1 | tr -d " "`
									 if [ $msgs_user1 -gt 3 ]
									 then
							          prints "PERFORMING IMAP FETCH ENVELOP" "ITS_1329310" 
                        echo > temporary.txt
							          exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							          echo -en "a login $user4 $user4\r\n" >&3
									      echo -en "a select INBOX\r\n" >&3
									      echo -en "a fetch 4:* envelope\r\n" >&3
									      echo -en "a logout\r\n" >&3
									      cat <&3 >>temporary.txt
									      cat temporary.txt >> debug.log
									 
									      invalid_field=$(cat temporary.txt | grep -i "()" | wc -l)
									      invalid_field=`echo $invalid_field | tr -d " " `
									 
									      if [ $invalid_field -gt 0 ]
									      then
									          prints "Invalid header field found in fetch envelope " "ITS_1329310" "1"
									 		      prints "Scenario 3 is not working fine "	"ITS_1329310" "1"
                            summary "FetchEnvelope for invalid-valid TO header" 1 "ITS-1329310 "												  
									      else
									          prints "Invalid header field not found in fetch envelope " "ITS_1329310" "2"
										 	      prints "Scenario 3 is working fine " "ITS_1329310" "2"
                            summary "FetchEnvelope for invalid-valid TO header" 0												  
									     fi
									 else
                      prints "Mails not delivered " "ITS_1329310" "1"
										  summary "FetchEnvelope for invalid-valid TO header" 1
                   fi
									 
									 ## CASE 4 : FOR DOC/PDF ATTACHMENT ###
									 prints "CASE 4 :  FOR DOC/PDF ATTACHMENT " "ITS_1329310" 
									
									 echo "From: $MAILFROM@openwave.com "  > message.txt 
							     echo "To: $user4@openwave.com; anyuser " >> message.txt
								   echo "Subject: Test mail" >> message.txt
							     echo >> message.txt
									 msg=`cat 32k-mime_doc`
							     echo "$msg"  >> message.txt									 
									 echo "From: $MAILFROM@openwave.com "  > message1.txt 
							     echo "To: all; anyuser " >> message1.txt
								   echo "Subject: Test mail" >> message1.txt
							     echo >> message1.txt
									 msg=`cat 64k-mime_pdf`
							     echo "$msg"  >> message1.txt									 
									 msg=`cat message.txt`
									 msg1=`cat message1.txt`
									 prints "Sending mail to $user4" "ITS_1329310" 
				           exec 3<>/dev/tcp/$MTAHost/$SMTPPort
				           echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				           echo -en "RCPT TO:$user4@openwave.com\r\n" >&3
				           echo -en "DATA\r\n" >&3
				           echo -en "$msg\r\n" >&3
				           echo -en ".\r\n" >&3
								   echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				           echo -en "RCPT TO:$user4\r\n" >&3
				           echo -en "DATA\r\n" >&3
				           echo -en "$msg1\r\n" >&3
				           echo -en ".\r\n" >&3
								   echo -en "QUIT\r\n" >&3
									 imboxstats $user4@openwave.com > boxstats.txt
				           msgs_user1=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				           msgs_user1=`echo $msgs_user1 | tr -d " "`
									 if [ $msgs_user1 -gt 5 ]
									 then
							          prints "PERFORMING IMAP FETCH ENVELOPE" "ITS_1329310" 
                        echo > temporary.txt
							          exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							          echo -en "a login $user4 $user4\r\n" >&3
									      echo -en "a select INBOX\r\n" >&3
									      echo -en "a fetch 6:* envelope\r\n" >&3
									      echo -en "a logout\r\n" >&3
									      cat <&3 >>temporary.txt
									      cat temporary.txt >> debug.log
										  
									      invalid_field=$(cat temporary.txt | grep -i "()" | wc -l)
									      invalid_field=`echo $invalid_field | tr -d " " `
									 
									      if [ $invalid_field -gt 0 ]
									      then
									          prints "Invalid header field found in fetch envelope " "ITS_1329310" "1"
										    	  prints "Scenario 4 is not working fine " "ITS_1329310" "1"
                            summary "FetchEnvelope for doc-pdf attachment" 1 "ITS-1329310 "												  
									      else
									          prints "Invalid header field not found in fetch envelope " "ITS_1329310" "2"
										    	  prints "Scenario 4 is working fine " "ITS_1329310" "2"
                            summary "Fetch Envelope for doc-pdf attachment" 0												  
									      fi										 
								     else
                        prints "Mails not delivered " "ITS_1329310" 
										  	summary "Fetch Envelope for doc-pdf attachment " 1
                     fi
									 
									 ## CASE 5 : FOR INVALID CC HEADER ###
									 prints "CASE 5 :  FOR INVALID CC HEADER " "ITS_1329310" 
									 
									 echo "From: $MAILFROM@openwave.com "  > message.txt 
							     echo "To: $user4@openwave.com; anyuser " >> message.txt
									 echo "CC: unknown" >> message.txt
								   echo "Subject: Test mail" >> message.txt
							     echo >> message.txt
									 echo "This is a test mail ..."  >> message.txt
									 
									 msg=`cat message.txt`
									 prints "Sending mail to $user4" "ITS_1329310" 
									 
				           exec 3<>/dev/tcp/$MTAHost/$SMTPPort
				           echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				           echo -en "RCPT TO:$user4\r\n" >&3
				           echo -en "DATA\r\n" >&3
				           echo -en "$msg\r\n" >&3
				           echo -en ".\r\n" >&3
     							 echo -en "QUIT\r\n" >&3
				                     						 
									 imboxstats $user4@openwave.com > boxstats.txt
				           msgs_user1=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				           msgs_user1=`echo $msgs_user1 | tr -d " "`
									 if [ $msgs_user1 -gt 7 ]
									 then
									    ## IMAP OPERATIONS START FROM HERE
							        prints "PERFORMING IMAP FETCH ENVELOPE" "ITS_1329310" 
										  prints "Connecting to imap" "ITS_1329310" 
                      echo > temporary.txt
							        exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							        echo -en "a login $user4 $user4\r\n" >&3
									    echo -en "a select INBOX\r\n" >&3
									    echo -en "a fetch 8:* envelope\r\n" >&3
									    echo -en "a logout\r\n" >&3
									    cat <&3 >>temporary.txt
									    cat temporary.txt >> debug.log
									 
									    invalid_field=$(cat temporary.txt | grep -i "()" | wc -l)
									    invalid_field=`echo $invalid_field | tr -d " " `
									    if [ $invalid_field -gt 0 ]
									    then
									        prints "Invalid header field found in fetch envelope " "ITS_1329310" "1"
										      prints "Scenario 5 is not working fine "	"ITS_1329310" "1"
                          summary "Fetch Envelope for invalid CC header" 1 "ITS-1329310 "											  
									    else
									        prints " Invalid header field not found in fetch envelope " "ITS_1329310" "2"
										      prints " Scenario 5 is working fine " "ITS_1329310" "2"
                          summary "Fetch Envelope for invalid CC header" 0 									  
									    fi
								    else
                      prints " Mails not delivered " "ITS_1329310" 
										  summary "Fetch Envelope for invalid CC header" 1
                    fi
									 ## CASE 6 : FOR INVALID BCC HEADER ###
									 prints "CASE 6 :  FOR INVALID BCC HEADER " "ITS_1329310" 
									 echo "From: $MAILFROM@openwave.com "  > message.txt 
							     echo "To: $user4@openwave.com; anyuser " >> message.txt
									 echo "BCC: unknown" >> message.txt
								   echo "Subject: Test mail" >> message.txt
							     echo >> message.txt
									 echo "This is a test mail ..."  >> message.txt
									 
									 msg=`cat message.txt`
									 prints "Sending mail to $user4" "ITS_1329310" 
				           exec 3<>/dev/tcp/$MTAHost/$SMTPPort
				           echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				           echo -en "RCPT TO:$user4\r\n" >&3
				           echo -en "DATA\r\n" >&3
				           echo -en "$msg\r\n" >&3
				           echo -en ".\r\n" >&3
      						 echo -en "QUIT\r\n" >&3
				           imboxstats $user4@openwave.com > boxstats.txt
				           msgs_user1=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				           msgs_user1=`echo $msgs_user1 | tr -d " "`
									 if [ $msgs_user1 -gt 8 ]
									 then
									      ## IMAP OPERATIONS START FROM HERE
										  
							          prints "PERFORMING IMAP FETCH ENVELOPE" "ITS_1329310" 
                        echo > temporary.txt
							          exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							          echo -en "a login $user4 $user4\r\n" >&3
									      echo -en "a select INBOX\r\n" >&3
									      echo -en "a fetch 9:* envelope\r\n" >&3
									      echo -en "a logout\r\n" >&3
									      cat <&3 >>temporary.txt
									      cat temporary.txt >> debug.log
									 
									      invalid_field=$(cat temporary.txt | grep -i "()" | wc -l)
									      invalid_field=`echo $invalid_field | tr -d " " `
									 
									      if [ $invalid_field -gt 0 ]
									      then
									          prints "Invalid header field found in fetch envelope " "ITS_1329310" "1"
										    	  prints "Scenario 6 is not working fine " "ITS_1329310" "1"
                            summary "Fetch Envelope for invalid BCC header" 1 "ITS-1329310 "											  
									     else
									          prints "Invalid header field not found in fetch envelope " "ITS_1329310" "2"
										      	prints "Scenario 6 is working fine "	 "ITS_1329310" "2"
											  		summary "Fetch Envelope for invalid BCC header" 0
									     fi										 
								    else
                      prints "Mails not delivered " "ITS_1329310" "1"
										  summary "Fetch Envelope for invalid BCC header" 1
                    fi									 
									  ## CASE 7 : FOR UTF-8 CHARACTERS IN SUBJECT LINE ###
									 prints "CASE 7 :  FOR UTF-8 CHARACTERS IN SUBJECT LINE " "ITS_1329310" 
									 echo "From: $MAILFROM@openwave.com "  > message.txt 
							     echo "To: $user4@openwave.com; anyuser " >> message.txt
									 echo "BCC: unknown" >> message.txt
								   echo "Subject: \x6a \x6b \x6c \x6d \x6e \x6f" >> message.txt
							     echo >> message.txt
									 echo "This is a test mail ..."  >> message.txt
									 
									 msg=`cat message.txt`
									 prints "Sendng mail to $user4" "ITS_1329310" 
				           exec 3<>/dev/tcp/$MTAHost/$SMTPPort
				           echo -en "MAIL FROM:$MAILFROM\r\n" >&3
				           echo -en "RCPT TO:$user4\r\n" >&3
				           echo -en "DATA\r\n" >&3
				           echo -en "$msg\r\n" >&3
				           echo -en ".\r\n" >&3
      						 echo -en "QUIT\r\n" >&3
				                         									 
									 imboxstats $user4@openwave.com > boxstats.txt
				           msgs_user1=$(grep "Total Messages Stored"  boxstats.txt | cut -d ":" -f2)
				           msgs_user1=`echo $msgs_user1 | tr -d " "`
									 if [ $msgs_user1 -gt 9 ]
									 then
							          prints "PERFORMING IMAP FETCH ENVELOPE" "ITS_1329310" 
                        echo > temporary.txt
							          exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
							          echo -en "a login $user4 $user4\r\n" >&3
									      echo -en "a select INBOX\r\n" >&3
									      echo -en "a fetch 10:* envelope\r\n" >&3
									      echo -en "a logout\r\n" >&3
									      cat <&3 >>temporary.txt
									      cat temporary.txt >> debug.log
									 
									      invalid_field=$(cat temporary.txt | grep -i "()" | wc -l)
									      invalid_field=`echo $invalid_field | tr -d " " `
									 
									      if [ $invalid_field -gt 0 ]
									      then
									          prints "Invalid header field found in fetch envelope " "ITS_1329310" "1"
											      prints "Scenario 7 is not working fine "	"ITS_1329310" "1"
                            summary "Fetch Envelope for UTF-8 characters in subject" 1 "ITS-1329310 "											  
									      else
									          prints "Invalid header field not found in fetch envelope " "ITS_1329310" "2"
										 	      prints "Scenario 7 is working fine " "ITS_1329310" "2"
                            summary "Fetch Envelope for UTF-8 characters in subject" 0										  
									     fi										 
								    else
                        prints "Mails not delivered " "ITS_1329310" "2"
											  summary "Fetch Envelope for UTF-8 characters in subject" 1
                    fi
							else
							    prints " ERROR : No messages in the inbox " "ITS_1329310" "1"
									summary "FETCH Envelope -all test cases" 7
							fi
								
              prints "Testing of Fetch envelope utility is completed" "ITS_1329310" 						
}
############################################# MAIN SCRIPT EXECUTION ###################################################################
#!/bin/bash
#set -x
		eval Result=0
		echo > summary.log
		echo > debug.log
		#trap for error and ctrl+c and call cleanup fucntion
		trap cleanup SIGHUP SIGINT SIGTERM
		#call for creating header files
		create_headerfiles
		
		#call function imsanity_version
    imsanity_version
		
		#call function checksetuptype to cehck whether setup is stateless or stateful
		check_setup_type
		
		#call clean up fucntion for setup clean up
		cleanup
		
		#change  /*/mss/serviceBlackoutSeconds: [30] 
	  set_config_keys "/*/mss/serviceBlackoutSeconds" "30" "1"
	  sleep 3
##############################################MAIN SCRIPT EXECUTION END HERE###########################################################
