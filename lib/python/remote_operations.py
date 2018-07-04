# -*- coding: utf-8 -*- 

def remote_operation(sshhost,username,passwd,cmds,\
    confirmflag = 1,\
    confirmobj = '',\
    confirmobjcount = 1,\
    sshport = 22,\
    outlog ='sshout.log',\
    errorlog ='ssherror.log',\
    paramikologenable = 0 \
    ):     
    
    """This function will used to do remote operations through ssh"""

    import paramiko                   # third party libs needs for ssh authentication
    import basic_class                # using log part

    sshhost = sshhost                 # ssh destination hosts,can be IP or resolvable hostnames
    username = username               # account-name used to establish ssh connection
    passwd = passwd                   # account-password used to establish ssh connection
    cmds = cmds                       # the commands going to run via ssh
    confirmflag = confirmflag         # if need check the outcome to confirm operation success or failed,default 1
    confirmobj = confirmobj           # the target need to to compared or searched or confirmed,default empty
    confirmobjcount = confirmobjcount # the accurance of confirmobj,default 1
    sshport = sshport                     # defaule ssh connection port ,22 by default
    outlog = outlog                       # normal ssh log file
    errorlog = errorlog                   # error ssh log file
    paramikologenable = paramikologenable # by default, paramikologdisabled ,set to 1 to enable            

    
    if paramikologenable == 1:
        paramiko.util.log_to_file('ssh.log') #set up paramiko logging,disbale by default
            
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname = sshhost, port = sshport, username = username, password = passwd)

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