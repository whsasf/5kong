# -*- coding: utf-8 -*- 
             
                       
def check_host_sshnonpassword_flag(sshhost,username,passwd,keyfile = '',sshport = 22,paramikologenable = 0):
    """ this function used to determine if target host can be sshed to without password """

    import paramiko                        # third party libs needs for ssh authentication
    import basic_class                     # using log part
    import os    

    sshhost = sshhost                      # ssh destination hosts,can be IP or resolvable hostnames
    username = username                    # account-name used to establish ssh connection
    passwd = passwd                        # account-password used to establish ssh connection
    
    if keyfile == '':                      # private key file
        keyfile = os.environ['HOME']+'/.ssh/id_rsa'
    else:
        keyfile = keyfile
        
    sshport = sshport                      # defaule ssh connection port ,22 by default
    paramikologenable = paramikologenable
    
    ssh_authtype_flag = -1   # 1 means auth with pubkey success, 0 means auth with password success, -1 means both auth types failed
    
    ssh_check = paramiko.SSHClient()
    ssh_check.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    if os.path.exists(keyfile):          # keyfile exist, will try to ssh withot password
        private_key = paramiko.RSAKey.from_private_key_file(keyfile)
        try:
            basic_class.mylogger_record.debug('Establishing ssh connection with pubkey to {} ...'.format(sshhost))
            ssh_check.connect(hostname = sshhost, port = sshport, username = username, pkey = private_key)
        except:
            basic_class.mylogger_record.debug('Establishing ssh connection with pubkey failed! Will continue try with password ...')
            basic_class.mylogger_record.debug('Establishing ssh connection with password ...')
            try:
                basic_class.mylogger_record.debug('Establishing ssh connection with password to {} ...'.format(sshhost))
                ssh_check.connect(hostname = sshhost, port = sshport, username = username, password = passwd)
            except:
                basic_class.mylogger_record.warning('Establishing ssh connection with password failed! Please check manually! ')               
                ssh_password_flag = -1
                basic_class.mylogger_record.debug('ssh_password_flag = '+str(ssh_password_flag))
                ssh_check.close()
                exit (1)
            else:
                basic_class.mylogger_record.debug('Establishing ssh connection with password success!')
                ssh_authtype_flag = 0
                basic_class.mylogger_record.debug('ssh_authtype_flag = '+str(ssh_authtype_flag))
                ssh_check.close()
                return(ssh_authtype_flag)
        else:
            basic_class.mylogger_record.debug('Establishing ssh connection with pubkey success!')
            ssh_authtype_flag = 1
            basic_class.mylogger_record.debug('ssh_authtype_flag = '+str(ssh_authtype_flag))
            ssh_check.close()
            return (ssh_authtype_flag)
                                              
    else:                                # keyfile not exist, will try to ssh with password
        try:
            basic_class.mylogger_record.debug('Establishing ssh connection with password to {} ...'.format(sshhost))
            ssh_check.connect(hostname = sshhost, port = sshport, username = username, password = passwd)
        except:
            basic_class.mylogger_record.warning('Establishing ssh connection with password failed! Please check manually! ')               
            ssh_password_flag = 2
            basic_class.mylogger_record.debug('ssh_password_flag = '+str(ssh_password_flag))
            exit (1)
        else:
            basic_class.mylogger_record.debug('Establishing ssh connection with password success!')
            ssh_authtype_flag = 0
            basic_class.mylogger_record.debug('ssh_authtype_flag = '+str(ssh_authtype_flag))
            ssh_check.close()
            return(ssh_authtype_flag)
               
    
        
def remote_operation(sshhost,cmds,\
    username = '',\
    passwd = '',\
    confirmflag = 1,\
    confirmobj = '',\
    confirmobjcount = 1,\
    sshport = 22,\
    keyfile = '',\
    outlog ='sshout.log',\
    errorlog ='ssherror.log',\
    paramikologenable = 0 \
    ):     
    
    """this function is used to pick up ssh auth with pubkey or passwordbased on the imput auth flag"""
    
    import os
    import global_variables  
    import basic_class
    
    sshhost = sshhost
    
    ssh_authtype_flag = global_variables.get_value('sshnonpassauth_flag_'+sshhost)
    if ssh_authtype_flag == str(1):
        basic_class.mylogger_record.debug('eatablishing ssh connection with pubkey to {} ...'.format(sshhost))
        return(remote_operation_with_sshpubkeyauth(sshhost,cmds,username,passwd,confirmflag,confirmobj,confirmobjcount,sshport,keyfile,outlog,errorlog,paramikologenable))
    elif ssh_authtype_flag == str(0):
        basic_class.mylogger_record.debug('eatablishing ssh connection with password to {} ...'.format(sshhost))
        return(remote_operation_with_sshpasswordauth(sshhost,cmds,username,passwd,confirmflag,confirmobj,confirmobjcount,sshport,keyfile,outlog,errorlog,paramikologenable))
    else:
        basic_class.mylogger_record.error('SSH establish failed,please check manually!!')
        exit(1)
   
    
def remote_operation_with_sshpubkeyauth(sshhost,cmds,\
    username = '',\
    passwd = '',\
    confirmflag = 1,\
    confirmobj = '',\
    confirmobjcount = 1,\
    sshport = 22,\
    keyfile = '',\
    outlog ='sshout.log',\
    errorlog ='ssherror.log',\
    paramikologenable = 0 \
    ):     
    
    """This function will used to do remote operations through ssh_pubkey_auth.
    """
    
    import paramiko                   # third party libs needs for ssh authentication
    import basic_class                # using log part
    import os
    import global_variables
    
    sshhost = sshhost                 # ssh destination hosts,can be IP or resolvable hostnames
    cmds = cmds                       # the commands going to run via ssh   
    
    if username == '':                # account-name used to establish ssh connection 
        username =   global_variables.get_value('root_account')
    else:
        username = username
        
    if passwd == '':                  # account-password used to establish ssh connection           
        passwd =   global_variables.get_value('root_passwd')      
    else:
        passwd = passwd 
        
    
    confirmflag = confirmflag         # if need check the outcome to confirm operation success or failed,default 1
    confirmobj = confirmobj           # the target need to to compared or searched or confirmed,default empty
    confirmobjcount = confirmobjcount # the accurance of confirmobj,default 1
    sshport = sshport                 # defaule ssh connection port ,22 by default
    
    if keyfile == '':                 # private key file
        keyfile = os.environ['HOME']+'/.ssh/id_rsa'
    else:
        keyfile = keyfile
                                 
    outlog = outlog                       # normal ssh log file
    errorlog = errorlog                   # error ssh log file
    paramikologenable = paramikologenable # by default, paramikologdisabled ,set to 1 to enable            

    
    if paramikologenable == 1:
        paramiko.util.log_to_file('ssh.log') #set up paramiko logging,disbale by default
    
    execute_flag = '' # execute flag:1 mesans success,0 means failed,-1 mesans blocked
           
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    basic_class.mylogger_record.debug('Establishing ssh connection with pubkey ...')
    private_key = paramiko.RSAKey.from_private_key_file(keyfile)
    try:
        ssh.connect(hostname = sshhost, port = sshport, username = username, pkey = private_key)
    except:
        basic_class.mylogger_record.debug('Establishing ssh connection with pubkey failed! Will continue try with password ...')
        basic_class.mylogger_record.debug('Establishing ssh connection with password ...')
        try:
            remote_operation_with_sshpasswordauth(sshhost,cmds,username,passwd,confirmflag,confirmobj,confirmobjcount,sshport,keyfile,outlog,errorlog,paramikologenable)
        except:
            basic_class.mylogger_record.warning('Establishing ssh connection with password failed! Please check manually! ')               
            exit (1)  
    else:
        basic_class.mylogger_record.debug('Established ssh connection with pubkey success!')   
            
    stdin, stdout, stderr = ssh.exec_command(cmds)
    okout = stdout.read()
    errout = stderr.read()
    #print ('err:'+str(errout,'utf-8'))
    #print ('ok:'+str(okout,'utf-8'))
    if len(errout) == 0:  
        sshout=str(okout,'utf-8')
        if confirmflag == 1:
            basic_class.mylogger_record.debug('confirmobj_count='+str(sshout.count(confirmobj)))
            if sshout.count(confirmobj) == confirmobjcount:
                basic_class.mylogger_record.debug('ssh success and target match')
                execute_flag = 1
                #print('\033[1;32mOperation success\033[0m')
            else:
                basic_class.mylogger_record.error('ssh success but target mismatch') 
                execute_flag = 0
                #print ('\033[1;31mOperation failed\033[0m')
        else:
            basic_class.mylogger_record.debug('ssh success and no need check target') 
            execute_flag = 1
    else:
        sshout=str(okout,'utf-8')+str(errout,'utf-8')
        basic_class.mylogger_record.error('ssh operation fail')
        execute_flag = -1
    basic_class.mylogger_record.debug("sshout=")
    basic_class.mylogger_recordnf.debug(sshout)
    return execute_flag,sshout   #in case of use 
   
    ssh.close()
    
    
def remote_operation_with_sshpasswordauth(sshhost,cmds,\
    username = '',\
    passwd = '',\
    confirmflag = 1,\
    confirmobj = '',\
    confirmobjcount = 1,\
    sshport = 22,\
    keyfile = '',\
    outlog ='sshout.log',\
    errorlog ='ssherror.log',\
    paramikologenable = 0 \
    ):     
    
    """This function will used to do remote operations through ssh_passwoed_auth.
    """
    
    import paramiko                   # third party libs needs for ssh authentication
    import basic_class                # using log part
    import os
    
    sshhost = sshhost                 # ssh destination hosts,can be IP or resolvable hostnames         
    cmds = cmds                       # the commands going to run via ssh
             
    if username == '':                # account-name used to establish ssh connection 
        username =   global_variables.get_value('root_account')
    else:
        username = username
        
    if passwd == '':                  # account-password used to establish ssh connection           
        passwd =   global_variables.get_value('root_passwd')      
    else:
        passwd = passwd     
        
    confirmflag = confirmflag         # if need check the outcome to confirm operation success or failed,default 1
    confirmobj = confirmobj           # the target need to to compared or searched or confirmed,default empty
    confirmobjcount = confirmobjcount # the accurance of confirmobj,default 1
    sshport = sshport                 # defaule ssh connection port ,22 by default                                 
    outlog = outlog                       # normal ssh log file
    errorlog = errorlog                   # error ssh log file
    paramikologenable = paramikologenable # by default, paramikologdisabled ,set to 1 to enable            

    
    if paramikologenable == 1:
        paramiko.util.log_to_file('ssh.log') #set up paramiko logging,disbale by default
    
    execute_flag = ''  # execute flag:1 mesans success,0 means failed,-1 mesans blocked      
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    basic_class.mylogger_record.debug('Establishing ssh connection with password ...')
    try:
        ssh.connect(hostname = sshhost, port = sshport, username = username, password = passwd)
    except:
        basic_class.mylogger_record.warning('Establishing ssh connection with password failed! Please check manually! ')               
        exit (1)
    else:
        basic_class.mylogger_record.debug('Established ssh connection with password success!')   
                    
    stdin, stdout, stderr = ssh.exec_command(cmds)
    okout = stdout.read()
    errout = stderr.read()
    #print ('err:'+str(errout,'utf-8'))
    #print ('ok:'+str(okout,'utf-8'))
    if len(errout) == 0:  
        sshout=str(okout,'utf-8')
        if confirmflag == 1:
            basic_class.mylogger_record.debug('confirmobj_count='+str(sshout.count(confirmobj)))
            if sshout.count(confirmobj) == confirmobjcount:
                basic_class.mylogger_record.debug('ssh success and target match')
                execute_flag = 1
                #print('\033[1;32mOperation success\033[0m')
            else:
                basic_class.mylogger_record.error('ssh success but target mismatch') 
                execute_flag = 0
                #print ('\033[1;31mOperation failed\033[0m')
        else:
            basic_class.mylogger_record.debug('ssh success and no need check target') 
            execute_flag = 1
    else:
        sshout=str(okout,'utf-8')+str(errout,'utf-8')
        basic_class.mylogger_record.error('ssh operation fail')
        execute_flag = -1
    basic_class.mylogger_record.debug("sshout=")
    basic_class.mylogger_recordnf.debug(sshout)
    return execute_flag,sshout   #in case of use 
   
    ssh.close()