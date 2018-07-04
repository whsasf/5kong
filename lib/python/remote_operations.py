# -*- coding: utf-8 -*- 

def remote_operation(sshhost,username,passwd,cmds,\
    confirmflag = 1,\
    confirmobj = '',\
    confirmobjcount = 1,\
    sshport = 22,\
    keyfile = '',\
    outlog ='sshout.log',\
    errorlog ='ssherror.log',\
    paramikologenable = 0 \
    ):     
    
    """This function will used to do remote operations through ssh.
       will first try use key auth if it exists in default place or user defined place ,
       then try password auth if key auth failed
    """
    
    import paramiko                   # third party libs needs for ssh authentication
    import basic_class                # using log part
    import os
    
    sshhost = sshhost                 # ssh destination hosts,can be IP or resolvable hostnames
    username = username               # account-name used to establish ssh connection
    passwd = passwd                   # account-password used to establish ssh connection
    cmds = cmds                       # the commands going to run via ssh
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
            
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    if os.path.exists(keyfile):          # keyfile exist, will try to ssh withot password
        basic_class.mylogger_record.debug('Establishing ssh connection withOUT password ...')
        private_key = paramiko.RSAKey.from_private_key_file(keyfile)
        try:
            ssh.connect(hostname = sshhost, port = sshport, username = username, pkey = private_key)
        except:
            basic_class.mylogger_record.debug('Establishing ssh connection withOUT password failed! Will continue try with password ...')
            basic_class.mylogger_record.debug('Establishing ssh connection with password ...')
            try:
                ssh.connect(hostname = sshhost, port = sshport, username = username, password = passwd)
            except:
                basic_class.mylogger_record.warning('Establishing ssh connection with password failed! Please check manually! ')               
                exit (1)
                            
    else:                                # keyfile not exist, will try to ssh with password
        basic_class.mylogger_record.debug('Establishing ssh connection with password ...')
        try:
            ssh.connect(hostname = sshhost, port = sshport, username = username, password = passwd)
        except:
            basic_class.mylogger_record.warning('Establishing ssh connection with password failed! Please check manually! ')               
            exit (1)
            
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
                #print('\033[1;32mOperation success\033[0m')
            else:
                basic_class.mylogger_record.error('ssh success but target mismatch') 
                #print ('\033[1;31mOperation failed\033[0m')
        else:
            basic_class.mylogger_record.debug('ssh success and no need check target') 
    else:
        sshout=str(okout,'utf-8')+str(errout,'utf-8')
        basic_class.mylogger_record.error('ssh operation fail')
    basic_class.mylogger_record.debug("sshout=")
    basic_class.mylogger_recordnf.debug(sshout)
    return sshout   #in case of use 
   
    ssh.close()