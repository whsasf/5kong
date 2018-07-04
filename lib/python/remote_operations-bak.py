# -*- coding: utf-8 -*- 

import paramiko     # third party libs needs for ssh authentication

#class Remote_Ops():

    """this class defines the basic functions of ssh operations"""
    
    def __init__(self,sshhost,user,passwd,sshport = 22,outlog ='sshout.log',errorlog ='ssherror.log',paramikologenable = 0):
        """initialize some paramaters"""
        
        self.sshhost = sshhost  # ssh destination hosts,can be IP or resolvable hostnames
        self.user = user        # account-name used to establish ssh connection
        self.passwd = passwd    # account-password used to establish ssh connection
       
        self.sshport = sshport                          # defaule ssh connection port ,22 by default
        self.outlog = outlog                            # normal ssh log file
        self.errorlog = errorlog                        # error ssh log file
        self.paramikologenable = paramikologenable      # by default, paramikologdisabled ,set to 1 to enable
    	      
    def remote_operations(self,cmds,confirmflag = 1,confirmobj = '',confirmobjcount = 1):     
        '''function to run commands via ssh'''
                
        self.cmds = cmds         # the commands going to run via ssh
        
        self.confirmflag = confirmflag         # if need check the outcome to confirm operation success or failed,default 1
        self.confirmobj = confirmobj           # the target need to to compared or searched or confirmed,default empty
        self.confirmobjcount = confirmobjcount # the accurance of confirmobj,default 1
        
        if self.paramikologenable == 1:
            paramiko.util.log_to_file('ssh.log') #set up paramiko logging,disbale by default
                
        self.ssh = paramiko.SSHClient()
        self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.ssh.connect(hostname = self.sshhost, port = self.sshport, username = self.user, password = self.passwd)
        self.stdin, self.stdout, self.stderr = self.ssh.exec_command(self.cmds)
        self.okout = self.stdout.read()
        self.errout = self.stderr.read()
        #print ('err:'+str(errout,'utf-8'))
        #print ('ok:'+str(okout,'utf-8'))
        if self.confirmflag == 1:
            if len(self.okout) == 0:  
                self.out=str(self.errout,'utf-8')
                print(self.out,end = '')
                
                #write error log to file
                with open(self.errorlog,'a') as self.file_object_err:
                    self.file_object_err.write(self.out)
                print (self.out.count(self.confirmobj))
                if self.out.count(self.confirmobj) == self.confirmobjcount:
                    print('\033[1;32m  Operation success\033[0m')
                else:
                    print ('\033[1;31m  Operation failed,no need to continue,please check'+self.errorlog+'!\033[0m')
            else:
                self.out=str(self.okout,'utf-8')
                print(self.out,end = '')
                
                #write out log to file
                with open(self.outlog,'a') as self.file_object_ok:
                    self.file_object_ok.write(self.out)
                print (self.out.count(self.confirmobj))
                if self.out.count(self.confirmobj) == self.confirmobjcount:

                    print('\033[1;32m  Operation success\033[0m')
                else:
                    print('\033[1;31m  Operation failed\033[0m')
        else:
            print ('\033[1;32m  Operation success\033[0m')
        self.ssh.close()