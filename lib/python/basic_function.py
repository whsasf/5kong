# -*- coding: utf-8 -*- 
# this module contains some functions that will used commenly


def welcome():
    """the welcome function used to print some welcome header when using this Wukong test suits
       also print headers in summary.log
    """
    
    import basic_class
    import global_variables
    
    summary_print_length = 100
    global_variables.set_value('summary_print_length',summary_print_length)
    
    owm_version = global_variables.get_value('owm_version')
    summary_title = '    MX TestCases Summary for '+owm_version+'    '
    
    if len(summary_title) % 2 == 0:    #make sure summary_title has even length
        pass
    else:
        summary_title += ' '
    
    dummy_length1 = int((summary_print_length - len(summary_title)) /2)
    basic_class.mylogger_summary.yes('='*dummy_length1+summary_title+'='*dummy_length1+'\n')

    # below 3 variables will be used in summaryfunction and statistics function later to generate a summary
    total_testcases_num = 0
    passed_testcases_num = 0
    failed_testcases_num = 0
    
    global_variables.set_value('total_testcases_num',total_testcases_num)
    global_variables.set_value('passed_testcases_num',passed_testcases_num)
    global_variables.set_value('failed_testcases_num',failed_testcases_num)
    
    
def print_mx_version():
    """print mx_version get from basic_function.create_log_folders()"""
    
    import global_variables
    import basic_class
    
    owm_version = global_variables.get_value('owm_version') 
    basic_class.mylogger_record.info('owm_version = '+owm_version)
    



def construct_mx_topology(root_user = '',root_pass = '',mx_user = ''):
    """ this function used to construct topology of MX environemnt,will create auto_user.vars file """
    
    import os
    import paramiko
    import global_variables
    import basic_class
    import remote_operations
    if root_user:
        root_account = root_user
    else:
        root_account = global_variables.get_value ('root_account') 
    
    if root_pass:
        root_passwd = root_pass
    else:
        root_passwd =  global_variables.get_value ('root_passwd')  
    
    if mx_user:
        mx_account = mx_user
    else:
        mx_account = global_variables.get_value ('mx_account')  
        
    basic_class.mylogger_record.debug('root_account = '+str(root_account))
    basic_class.mylogger_record.debug('root_passwd = '+str(root_passwd))
    basic_class.mylogger_record.debug('mx_account = '+str(mx_account))
    
    # Check if auto-user.vars file exist
    initialpath,mx_seed_host_nums = global_variables.get_values ('initialpath','mx_seed_host_nums') 
    basic_class.mylogger_record.debug('target path = '+str(initialpath+'/etc/auto-user.vars'))
    exist_flag_auto_vars = os.path.exists(initialpath+'/etc/auto-user.vars')
    basic_class.mylogger_record.debug('exist_flag_auto_vars = '+str(exist_flag_auto_vars))
    # Determine if need create a new file
    if exist_flag_auto_vars:
        ctime_auto_vars = os.path.getctime(initialpath+'/etc/auto-user.vars')  # create time of auto-user.vars
        mtime_manu_vars = os.path.getmtime(initialpath+'/etc/manu-user.vars')  # last modify time of manu-user.vars
        basic_class.mylogger_record.debug('ctime_auto_vars = '+str(ctime_auto_vars))
        basic_class.mylogger_record.debug('mtime_manu_vars = '+str(mtime_manu_vars))
        
        if mtime_manu_vars >= ctime_auto_vars:  # mesans manu-user.vars have been modified
            regenerate_flag = 1                   # create auto-user.vars again      
            basic_class.mylogger_record.debug('regenerate_flag = '+str(regenerate_flag))
            basic_class.mylogger_record.info('Regenerating auto-user.vars again ...')
        else:                                   # skip to create auto-user.vars 
            regenerate_flag = 0                 
            basic_class.mylogger_record.debug('regenerate_flag = '+str(regenerate_flag))
            basic_class.mylogger_record.info('Skip Regenerating auto-user.vars ...')
    else:                                       # create auto-user.vars if not exist
        regenerate_flag = 1
        basic_class.mylogger_record.debug('regenerate_flag = '+str(regenerate_flag))
        basic_class.mylogger_record.info('Regenerating auto-user.vars again ...')
                
    if regenerate_flag == 1:   
        total = [] # used to store all fetched variabled
        host_dict,port_dict,addr_dict,cass_dict ={},{},{},{}
        allhost_common_user_home = ''
        
        for xyz in range(int(mx_seed_host_nums)):
            seed_host = global_variables.get_value('mx_seed_host{}_ip'.format(xyz+1))
            basic_class.mylogger_record.debug('seed_host = '+str(seed_host))
            #ssh_allhost = paramiko.SSHClient()
            #ssh_allhost.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            #ssh_allhost.connect(seed_host,22,root_account,root_passwd)
            
            
            #tmp_cmd1='cat /etc/passwd|grep '+mx_account+'|cut -d\':\' -f6'
            #basic_class.mylogger_record.debug('tmp_cmd1 = '+str(tmp_cmd1))
            #stdin,stdout1,stderr=ssh_allhost.exec_command(tmp_cmd1)
            #if (len(stderr.read())==0):
            #    allhost_common_user_home=stdout1.read().strip().decode()
            #else:
            #    basic_class.mylogger_record.error('SSH Error!')
            #    exit (1)
            #basic_class.mylogger_record.debug('allhost_common_user_home = '+str(allhost_common_user_home))
                
            #get hosts and hosts, ip, addrs                
            tmp_cmd2 = 'imconfget  -hosts | grep -v cluster'
            basic_class.mylogger_record.debug('tmp_cmd2 = '+str(tmp_cmd2))
            #stdin,stdout2,stderr=ssh_allhost.exec_command(tmp_cmd2)
            stdout2 = remote_operations.remote_operation(seed_host,root_account,root_passwd,'su - {0} -c "{1}"'.format(mx_account,tmp_cmd2),0)
            h_lists=stdout2.split('\n')[0:-2]
            print(h_lists)
            i = 0
            for h_list in h_lists:
                h_list = h_list.split()[0]
                key = 'mx'+str(xyz+1)+'_host'+str(i+1)
                value = str(h_list)
                addr_dict[key] = value
                tmp_cmd3="grep "+str(h_list)+" /etc/hosts|awk \'{print $1}\' | head -1"
                basic_class.mylogger_record.debug('tmp_cmd3 = '+str(tmp_cmd3))
                #stdin,stdout3,stderr=ssh_allhost.exec_command(tmp_cmd3)
                stdout3 = remote_operations.remote_operation(seed_host,root_account,root_passwd,'su - {0} -c "{1}"'.format(mx_account,tmp_cmd3),0)
                tmpip=stdout3.split('\n')[0:-1][0]
                print(tmpip)
                key = 'mx'+str(xyz+1)+'_host'+str(i+1)+"_ip"
                value = ''.join(tmpip[0].split())
                addr_dict[key] = value
                i += 1
            
            
            tmp_cmd4 = 'imconfcontrol -ports'
            basic_class.mylogger_record.debug('tmp_cmd4 = '+str(tmp_cmd4))
            #stdin,stdout4,stderr=ssh_allhost.exec_command(tmp_cmd4)
            stdout4 = remote_operations.remote_operation(seed_host,root_account,root_passwd,'su - {0} -c "{1}"'.format(mx_account,tmp_cmd4),0)
            #if (len(stderr.read())==0):
            tmp_list = stdout4.split('\n')[0:-1]
            for hostports in tmp_list:
                tmp_a = hostports.split()
                
                if tmp_a[0].isdigit():
                    #print(tmp_a[2])
                    #print('===>'+str(tmp_a))
                    tmp_cmd5 = 'imconfget -server '+ tmp_a[2]
                    basic_class.mylogger_record.debug('tmp_cmd5 = '+str(tmp_cmd5))
                    #stdin,stdout5,stderr=ssh_allhost.exec_command(tmp_cmd5)
                    stdout5 = remote_operations.remote_operation(seed_host,root_account,root_passwd,'su - {0} -c "{1}"'.format(mx_account,tmp_cmd5),0)
                    s_list=stdout5.split()[0:-1]
                    print(s_list)
                    for serverhosts in s_list:
                        server_tmp=serverhosts.split()
                        #print(len(server_tmp))
                        if len(server_tmp) > 0:
                            #print('-->'+str(server_tmp))
                            for i in range(len(server_tmp)):
                                #print('i='+str(i))
                                key = 'mx'+str(xyz+1)+'_'+tmp_a[2]+'_host'+str(i+1)
                                value = server_tmp[i]
                                host_dict[key] = value
                                key = 'mx'+str(xyz+1)+'_'+tmp_a[2]+'_host'+str(i+1)+'_ip'
                                value = [addr_dict.get(k+'_ip') for k,v in addr_dict.items() if v == server_tmp[i]]
                                host_dict[key] = value[0]
                                #print(host_list)
                                key = 'mx'+str(xyz+1)+'_'+tmp_a[2]+'_host'+str(i+1)+'_'+tmp_a[3].replace('.','_')
                                value = tmp_a[0]
                                port_dict[key] = value
                                #print(port_list)
                        else:
                            key = 'mx'+str(xyz+1)+'_'+tmp_a[2]+'_'+tmp_a[3].replace('.','_')
                            value = tmp_a[0]
                            port_dict[key] = value                                           
                else:   #skip the titles 
                    pass

                 
            #get cassandra info
            tmp_cmd6 = 'grep hostInfo config/config.db | cut -d \':\' -f 3'
            basic_class.mylogger_record.debug('tmp_cmd6 = '+str(tmp_cmd6))
            #stdin,stdout6,stderr=ssh_allhost.exec_command(tmp_cmd6)
            stdout6 = remote_operations.remote_operation(seed_host,root_account,root_passwd,'su - {0} -c "{1}"'.format(mx_account,tmp_cmd6),0)
            b_n = stdout6.split('\n')[0]
            blobtier = b_n[0].split()[0]
            tmp_cmd7 = "grep "+str(blobtier)+" /etc/hosts|awk \'{print $1}\' | head -1"
            basic_class.mylogger_record.debug('tmp_cmd7 = '+str(tmp_cmd7))
            #stdin,stdout7,stderr=ssh_allhost.exec_command(tmp_cmd7)
            stdout7 = remote_operations.remote_operation(seed_host,root_account,root_passwd,'su - {0} -c "{1}"'.format(mx_account,tmp_cmd7),0)
            tmp_ip = stdout7.split('\n')[0]
            blob_ip=tmp_ip[0].split()[0] 
            cass_dict['mx'+str(xyz+1)+'_cassblob_hosts'] =str(blobtier)
            cass_dict['mx'+str(xyz+1)+'_cassblob_ip'] = str(blob_ip) 
            
            tmp_cmd8 = 'grep cassandraMDCluster config/config.db | cut -d \'[\' -f 2| cut -d \']\' -f1 '
            basic_class.mylogger_record.debug('tmp_cmd8 = '+str(tmp_cmd8))
            #stdin,stdout8,stderr=ssh_allhost.exec_command(tmp_cmd8)
            stdout8 = remote_operations.remote_operation(seed_host,root_account,root_passwd,'su - {0} -c "{1}"'.format(mx_account,tmp_cmd8),0)
            m_n = stdout8.split('\n')[0:-1]
            metadata = m_n[0].split()[0]
            tmp_cmd9 = "grep "+str(metadata)+" /etc/hosts|awk \'{print $1}\' | head -1"
            #stdin,stdout9,stderr=ssh_allhost.exec_command(tmp_cmd9)
            stdout9 = remote_operations.remote_operation(seed_host,root_account,root_passwd,'su - {0} -c "{1}"'.format(mx_account,tmp_cmd9),0)
            tmp_ip = stdout9.split('-n')[0]
            meta_ip = tmp_ip[0].split()[0]
            cass_dict['mx'+str(xyz+1)+'_cassmeta_hosts'] = str(metadata)
            cass_dict['mx'+str(xyz+1)+'_cassmeta_ip'] = str(meta_ip)
        
        
        user_var_file = open('etc/auto-user.vars', "w")
        #tmp_list=list(set(host_list+port_list+addr_list+cass_list))
        for tck ,tcv in sorted(addr_dict.items(),key=lambda addr_dict:addr_dict[0]):
            total.append(tck+' = '+tcv)
        for tck ,tcv in sorted(host_dict.items(),key=lambda host_dict:host_dict[0]):
            total.append(tck+' = '+tcv)        
        for tck ,tcv in sorted(port_dict.items(),key=lambda port_dict:port_dict[0]):       
            total.append(tck+' = '+tcv)          
        for tck ,tcv in sorted(cass_dict.items(),key=lambda cass_dict:cass_dict[0]):       
            total.append(tck+' = '+tcv)     
        basic_class.mylogger_record.debug('total = '+str(total))
        
        for item in sorted(total):
            user_var_file.write(item+"\n") 
        user_var_file.close()
    else:
        pass       
        
    basic_class.mylogger_record.debug('Importing auto-user.vars ...')          
    global_variables.import_variables_from_file([initialpath+'/etc/auto-user.vars'])# read auto generated users.vars     


    
def variables_prepare(initialpath):
    """ this function is used to get some predefined variables """    

    import global_variables         
    global_variables._init()
    global_variables.set_value('initialpath',initialpath)
    #global_variables.set_value('temppath',initialpath+'/lib/temp')
    #global_variables.set_value('num',1)
    global_variables.set_value('setup_num',1)     # used to count setup scripts numbers in function traverse_judge
    global_variables.set_value('run_num',1)       # used to count run scripts numbers in function traverse_judge
    global_variables.set_value('teardowm_num',1)  # used to count teardown scripts numbers in function traverse_judge
    global_variables.import_variables_from_file([initialpath+'/etc/global.vars',initialpath+'/etc/manu-user.vars',initialpath+'/etc/contacts.txt'])# read all pre-defined vars

    
def parse_args():
    """this function used to parse the arguements providded,help determine the testcase location,logging levels,notify_send,etc"""
     
    import sys
    import global_variables
    
    argvnum = len(sys.argv) # number of total argements,the real arguements number is 
    argvlist = sys.argv[1:] # total real arguments(shell name excludded)
    global_variables.set_value('argvnum',argvnum)   # store length of arguments into dict 
    global_variables.set_value('argvlist',argvlist) # store arguments into dict
    
    if argvlist.count('-n') == 1: # need send notify after testing
        send_notify_flag = 1
        global_variables.set_value('send_notify_flag',send_notify_flag)
        argvlist.remove('-n')
    else:                      # send_notify is disabled
        send_notify_flag = 0
        global_variables.set_value('send_notify_flag',send_notify_flag)        



def parse_chloglevel():
    """this function gte the chloglevel of this test"""
    
    parse_args()   # get all args            
    import global_variables
    import basic_class
    
    argvlist = global_variables.get_value('argvlist')           # get argvlist of arguments
    if argvlist.count('-v') > 1 or argvlist.count('-vv') > 1 or argvlist.count('-V') > 1 or argvlist.count('-VV') > 1:   # determine the chloglevel (displayed to screen)
        basic_class.mylogger_record.error("multiple '-v' or '-vv' detected,please make sure only one entered!")
        exit()
    elif argvlist.count('-v') == 1 or argvlist.count('-V') == 1 or argvlist.count('-vv') == 1 or  argvlist.count('-VV') == 1:
        if '-v' in argvlist:
            chloglevel = 'WARNING'
            argvlist.remove('-v')
        elif '-V' in argvlist:
            chloglevel = 'WARNING'
            argvlist.remove('-V')
        elif '-vv' in argvlist:
            chloglevel = 'DEBUG'
            argvlist.remove('-vv')
        else:
            chloglevel = 'DEBUG'
            argvlist.remove('-VV')
                    
    else:
        chloglevel = 'ERROR'
    global_variables.set_value('chloglevel',chloglevel) # store chloglevel into dict
    return chloglevel

            
def parse_testcaselocation(testcaselocation):
    """this function will chelk if the testcaselocation is:
    
       (1)the default testcase location:TestCases folder
       (2)some (any) individual folders of some testcases
       (3)a file ,that contains the location of testcases"""      
     
    import os
    import basic_class
    
    # print(testcaselocation)   
    # print(len(testcaselocation))
    if len(testcaselocation) == 0 or  len(testcaselocation) == 1:
        if testcaselocation == [] or (testcaselocation[0].strip() == 'test_cases' and testcaselocation[-1] == 'test_cases'):  
            basic_class.mylogger_record.debug('The testcase located in:')
            basic_class.mylogger_recordnf.debug(str(['test_cases']))
            return (['test_cases'])                        # using default testcase location
        elif os.path.isfile(testcaselocation[0].strip()):  # using testcase.list file
            with open(testcaselocation[0].strip()) as file_obj:
                lines_tmp = file_obj.read().splitlines()
            lines = []
            basic_class.mylogger_record.debug('The testcase located in:') 
            for line in lines_tmp:
                if not str(line.strip()).startswith('#'):  # exclude the commented lines
                    basic_class.mylogger_recordnf.debug(line.strip())
                    lines.append(line.strip())             # only return the read testcase lines 
                else:
                    pass
            return sorted(lines)
        else:
            basic_class.mylogger_record.debug('The testcase located in:') 
            basic_class.mylogger_recordnf.debug(testcaselocation[0])  
            testcaselocation
            return testcaselocation                        # single specific testcase location
    else:
        basic_class.mylogger_record.debug('The testcase located in:') 
        for testcase in testcaselocation:
            basic_class.mylogger_recordnf.debug(testcase)  
        return sorted(testcaselocation)                           # multiple specific testcase locations


def decide_import_or_reload(case_name,count_type,tmp_type):
    """this function used to deteimine import or repoad the testcases scripts,only the first time use import"""       
    
    import basic_class
    import global_variables
    import importlib
    import time
    
    basic_class.mylogger_recordnf.title('[-->Executing '+case_name+'.py ...]') 
    count_num = int(global_variables.get_value('{}'.format(count_type)))
    if count_num == 1:
        tm_type = importlib.import_module (case_name)
        global_variables.set_value('{}'.format(tmp_type),tm_type)
        count_num += 1
        global_variables.set_value('{}'.format(count_type),count_num)
    else:
        tm_type = global_variables.get_value(tmp_type)
        importlib.reload(tm_type)
    
                                
def traverse_judge(casename,currentlists):
    """decide import or reload testcase file"""
    
    import os
    import sys
    import global_variables
    import time
    import basic_class

    testcasename = casename+'.py'
    
    if  testcasename in currentlists:
        
        path = os.getcwd()        
        sys.path.append(path)    
        
        if 'setup' in casename.lower():
            decide_import_or_reload('setup','setup_num','tmp_module_setup')            
        elif 'run' in casename.lower():
            decide_import_or_reload('run','run_num','tmp_module_run')    
        elif 'teardown' in casename.lower():
            decide_import_or_reload('teardown','teardowm_num','tmp_module_teardown')
        else:
            basic_class.mylogger_record.warn('please make sure all test scripys name in "setup.py","run.py" or "teardown.py"!!')    
            exit (1)
            
        sys.path.remove(path)    # remove the path just added,will add a new path for next testcase
                          
def traverse(Path):
    """traverse testcases under give Path,normal first execute setup,then run,last teardown for each testcase"""
    
    import os
    import sys
    import basic_class
    import global_variables 
    import datetime
    
    os.chdir(Path)                 # switch to current Path
    
    currentlists = sorted(os.listdir('.')) # get current folder and file names in current path
    for list in currentlists:      # delete the hiden files and folders
        if list.startswith('.'):
            currentlists.remove(list)
    for list in currentlists:      # delete the '__pycache__/' folderss
        if '__pycache__' in list:
            currentlists.remove(list)
    
    # print test case title if this is a final testcase folder ,means no sub folders
    #bottom_flag = [os.path.isfile(list) for list in currentlists]
    no_subfolder_flag = [os.path.isfile(list) for list in currentlists]
    has_script_flag = []
    for list in currentlists:
        if 'setup.py' in list.lower():
            has_script_flag.append('True')
        if 'run.py' in list.lower():
            has_script_flag.append('True')
        if 'teardown.py' in list.lower():
            has_script_flag.append('True')    
    
    testsuit_flag = []  # determibe if sub fldr contains script or not
    for root, dirs, files in os.walk('.'):
        for file in files:
            if 'setup.py' in file.lower():
                testsuit_flag.append('True')
            if 'run.py' in file.lower():
                testsuit_flag.append('True')
            if 'teardown.py' in file.lower():
                testsuit_flag.append('True')                
    basic_class.mylogger_record.debug('no_subfolder_flag= '+str(no_subfolder_flag))  
    basic_class.mylogger_record.debug('has_script_flag= '+str(has_script_flag)) 
    basic_class.mylogger_record.debug('testsuit_flag= '+str(testsuit_flag))    
                                 
    if has_script_flag.count('True') > 0 and has_script_flag.count('True') == testsuit_flag.count('True'):    #  contains 'setup' or 'run' or 'teardown' in current fplder,and no scripts in sub folders,is a testcase folder 
        testcase_name = os.getcwd().split('/')[-1]
        #basic_class.mylogger_recordnf.title('\n'+'-'*(17+len(testcase_name)))
        basic_class.mylogger_recordnf.title('\n<---Testcase: '+testcase_name+' --->')

        testcase_starttime = datetime.datetime.now() # record testcase start time
        basic_class.mylogger_record.debug('testcase_starttime= '+str(testcase_starttime)) 
        global_variables.set_value('testcase_starttime',testcase_starttime)
            
        #basic_class.mylogger_recordnf.title('-'*(17+len(testcase_name)))
        global_variables.set_value('testcase_name',testcase_name)
    elif  has_script_flag.count('True') == 0 and  testsuit_flag.count('True') > 0: # has sub folders ,and sub folder contains scripts, is a test suits folder
        folder_name = os.getcwd().split('/')[-1]                               
        #basic_class.mylogger_recordnf.title('\n'+'='*(17+len(folder_name)))
        basic_class.mylogger_recordnf.title('\n<<===Testsuit: '+folder_name+' ===>>') 
        #basic_class.mylogger_recordnf.title('='*(17+len(folder_name))) 
    else:
        pass # ignore currentpath        
    #print('currentlists:',currentlists)
    
    traverse_judge('setup',currentlists)      # run setup if exists
    traverse_judge('run',currentlists)        # run run if exists                
    for list in currentlists:
        if os.path.isdir(list):
            traverse(list)
            #os.chdir(list)
            #print (os.getcwd())        
    traverse_judge('teardown',currentlists)   # run teardown if exists     
    testcase_stoptime = datetime.datetime.now() # record testcase stop time
    global_variables.set_value('testcase_stoptime',testcase_stoptime) 
    basic_class.mylogger_record.debug('testcase_stoptime= '+str(testcase_stoptime))    
    #os.system('chmod +x setup.py;./setup.py')      
    os.chdir('..')        



def execute(Paths,initialpath):
    """this function is used to traverse all folders and files under target path,and run specific scripts"""
    
    import os 
    import basic_class
    import datetime
    import global_variables
    
    # print title to indicate begin running all testcases
    basic_class.mylogger_recordnf.title('\n[[Section2: Executing all testcases as required  ... ]]')
    
    test_starttime = datetime.datetime.now()
    basic_class.mylogger_record.debug('tests start at: '+str(test_starttime))
    global_variables.set_value('test_starttime',test_starttime)
    
    for Path in Paths:         # traverse each Path in Paths
        os.chdir(initialpath)  # switch to initialpath ,initialze
        traverse(Path)         # execute testcases under Path


def create_log_folders():
    """this function will fetch mx version and create log and summary folders based on mx_version"""
    import remote_operations
    import global_variables
    #import basic_class
    import time
    import os
    
    mx_seed_host1_ip = global_variables.get_value('mx_seed_host1_ip')
    root_account = global_variables.get_value('root_account') # root by default
    root_passwd = global_variables.get_value('root_passwd')   # 
    sshport = global_variables.get_value('sshport')
    
    #owm_common_version = remote_operations.remote_operation(mx1_host1_ip,root_account,root_passwd,'rpm -qa|grep owm|grep owm-common',1,'owm-common-',1)
    import paramiko
    ssh0 = paramiko.SSHClient()
    ssh0.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh0.connect(hostname = mx_seed_host1_ip, port = sshport, username = root_account, password = root_passwd)
    cmds = 'rpm -qa|grep owm|grep owm-common' 
    stdin, stdout, stderr = ssh0.exec_command(cmds)
    okout = stdout.read()
    errout = stderr.read()    
    ssh0.close()
    if len(errout) == 0:  
        out=str(okout,'utf-8')
    else:
        out=str(errout,'utf-8')
        print("Some error seems happened:\n"+out)
        exit(1)
    
    owm_version = out.split('owm-common-')[1].strip()
    global_variables.set_value('owm_version',owm_version)
    #print("Some error seems happened:\n"+out)
    initialpath = global_variables.get_value('initialpath')
    currenttime = time.strftime("%Y-%m-%d-%H-%M")
    foldername = owm_version+'-'+'{}'.format(currenttime)
    if os.path.exists('logs/'+foldername):
        try:
            os.remove('logs/'+foldername+'/alltestcases.log')
        except FileNotFoundError:
            pass
    else:
        os.makedirs('logs/'+foldername)
    if os.path.exists('summary/'+foldername):
        try:
            os.remove('summary/'+foldername+'/summary.log')
        except FileNotFoundError:
            pass
    else:
        os.makedirs('summary/'+foldername)
    
    global_variables.set_value('logpath',initialpath+'/logs/'+foldername)
    global_variables.set_value('summarypath',initialpath+'/summary/'+foldername)
    


def summary(result_lists,tc_name = ''):
    """this function will analyze the test outcome,determin if tests successfully or not,and record results to summary.log"""
    
    import basic_class
    import global_variables
    
    basic_class.mylogger_record.debug('result_lists= '+str(result_lists))
    total_testcases_num = global_variables.get_value('total_testcases_num')
    passed_testcases_num = global_variables.get_value('passed_testcases_num')
    failed_testcases_num = global_variables.get_value('failed_testcases_num')
        
    success_flag = 0                   # use to accumulate the 'success' number,from 0
    target = len(result_lists)         # for result_lists=['threshold success', 'count success'] ,target wil be 2 (success)
                                       # if  result_lists=['threshold success', 'count faile'],target still be 2, but will failed
    if tc_name != '':                  # will use customer input testcase name to print 
        testcase_name = tc_name
    else:                              # will use default testcase name got from 'os.getcwd().split('/')[-1]'
        testcase_name = global_variables.get_value('testcase_name')           	
    
    summary_print_length = int(global_variables.get_value('summary_print_length'))
    for result in result_lists:
        if 'success' in result.lower():
            success_flag += 1
    
    dummy_length2 = int(summary_print_length - len(testcase_name) -7)
    basic_class.mylogger_record.debug('success_flag= '+str(success_flag)) 
    if success_flag == target:
        basic_class.mylogger_recordnf.yes('----------Testcase: '+testcase_name+' passed.----------\n') 
        basic_class.mylogger_summary.yes(testcase_name+' '+'.'*dummy_length2+' [PASS]') 
        passed_testcases_num += 1
        global_variables.set_value('passed_testcases_num',passed_testcases_num)   # update passed_testcases_num
    else:
        basic_class.mylogger_recordnf.no('----------Testcase: '+testcase_name+' failed.----------\n') 
        basic_class.mylogger_summary.no(testcase_name+' '+'.'*dummy_length2+' [FAIL]') 
        failed_testcases_num += 1
        global_variables.set_value('failed_testcases_num',failed_testcases_num)   # update total_testcases_num
        
    total_testcases_num += 1
    global_variables.set_value('total_testcases_num',total_testcases_num)         # update total_testcases_num



def statistics():
    """thid function used to statistic total tetscases numbers ,and passed numbers ,and failed numbers"""
    
    import basic_class
    import global_variables
    import datetime
    import os
    import time
    import smtp_operations    
    
    failed_testcases = []  # used to store the failed testcases to print in email later
    owm_version = global_variables.get_value('owm_version')
    test_starttime = global_variables.get_value('test_starttime')
    test_endtime = datetime.datetime.now()
    basic_class.mylogger_record.debug('tests end at: '+str(test_endtime))
    time_costs = (test_endtime - test_starttime).seconds/60
    
    # merge testcases from Imsanity and IMAP Colllider
    
    # testcases numbers for imsanity and IMAP_collider
    imsanity_total = 0
    imsanity_pass = 0
    imsanity_fail = 0
    imap_collider_total = 0
    imap_collider_pass = 0
    imap_collider_fail = 0
    # get outside testcase names

    send_notify_flag = global_variables.get_value('send_notify_flag')
    summarypath = global_variables.get_value('summarypath')  
    summary_print_length = int(global_variables.get_value('summary_print_length'))
    imsanity_summary_path = summarypath+'/imsanity-summary.log'
    imapcollider_summary_path = summarypath+'/IC_Summary.log'
    imsanity_summary_exist = os.path.exists(imsanity_summary_path)
    imapcollider_summary_exist = os.path.exists(imapcollider_summary_path)   
    
    if imsanity_summary_exist:  # imsanity-summary.log exists
        with open(imsanity_summary_path) as file1_obj:
            lines = file1_obj.read().splitlines()
        for line in lines:
            if '[PASS]' in line:
                imsanity_total += 1
                imsanity_pass += 1
                tmp_out = line.split()
                real_testcase = 'Imsanity|'+tmp_out[0]
                dummy_length3 = int(summary_print_length - len(real_testcase) -7)
                basic_class.mylogger_summary.yes(real_testcase+' '+'.'*dummy_length3+' '+tmp_out[3]+' '+tmp_out[4])                       
            elif '[FAIL]' in line:
                imsanity_total += 1
                imsanity_fail += 1
                tmp_out = line.split()
                real_testcase = 'Imsanity|'+tmp_out[0]   
                dummy_length3 = int(summary_print_length - len(real_testcase) -7)                
                basic_class.mylogger_summary.no(real_testcase+' '+'.'*dummy_length3+' '+tmp_out[3]+' '+tmp_out[4])
            else:
                pass  #skip          
    else:                       # imsanity-summary.log not exists
        basic_class.mylogger_record.debug('No imsanity summary log find, skip it.')   
    
    if imapcollider_summary_exist:  # imap_collider-summary.log exists
        with open(imapcollider_summary_path) as file2_obj:
            lines = file2_obj.read().splitlines()
        for line in lines:
            if 'PASSED' in line:
                imap_collider_total += 1
                imap_collider_pass += 1
                tmp_out = line.split(' ==> ')
                real_testcase = 'IMAP_Collider|'+tmp_out[0]
                dummy_length3 = int(summary_print_length - len(real_testcase) -7)
                basic_class.mylogger_summary.yes(real_testcase+' '+'.'*dummy_length3+' [PASS]')                       
            elif 'FAILED' in line:
                imap_collider_total += 1
                imap_collider_fail += 1
                tmp_out = line.split()
                real_testcase = 'IMAP_Collider|'+tmp_out[0]   
                dummy_length3 = int(summary_print_length - len(real_testcase) -7)                
                basic_class.mylogger_summary.no(real_testcase+' '+'.'*dummy_length3+' [FAIL]')
            else:
                pass  #skip          
    else:                       # imsanity-summary.log not exists
        basic_class.mylogger_record.debug('No imap_collider summary log find, skip it.')   
        
       
    total_testcases_num = global_variables.get_value('total_testcases_num')
    passed_testcases_num = global_variables.get_value('passed_testcases_num')
    failed_testcases_num = global_variables.get_value('failed_testcases_num')
        
                
    # print time info to summary.log
    basic_class.mylogger_summary.yes('\n=============================================')
    basic_class.mylogger_summary.yes('Test started at: '+str(test_starttime))
    basic_class.mylogger_summary.yes('Test endded  at: '+str(test_endtime))
    basic_class.mylogger_summary.yes('Total  time  is: {:.2f} minutes'.format(time_costs))
    basic_class.mylogger_summary.yes('=============================================')
        
    # print statistics to summary.log       
    basic_class.mylogger_summary.yes('Total number of Test Cases: '+str(total_testcases_num+imsanity_total+imap_collider_total))
    basic_class.mylogger_summary.yes('PASS:                       '+str(passed_testcases_num+imsanity_pass+imap_collider_pass))
    basic_class.mylogger_summary.yes('FAIL:                       '+str(failed_testcases_num+imsanity_fail+imap_collider_fail))
            
    # print time and statistics info to screen and log  
    basic_class.mylogger_recordnf.info('\n=============================================')
    basic_class.mylogger_recordnf.info('Test started at: '+str(test_starttime))
    basic_class.mylogger_recordnf.info('Test endded  at: '+str(test_endtime))
    basic_class.mylogger_recordnf.info('Total  time  is: {:.2f} minutes'.format(time_costs))
    basic_class.mylogger_recordnf.info('=============================================') 
    basic_class.mylogger_recordnf.info('Total number of Test Cases: '+str(total_testcases_num+imsanity_total+imap_collider_total))
    basic_class.mylogger_recordnf.info('PASS:                       '+str(passed_testcases_num+imsanity_pass+imap_collider_pass))
    basic_class.mylogger_recordnf.info('FAIL:                       '+str(failed_testcases_num+imsanity_fail+imap_collider_fail)+'\n')          
    
    # send notify or not 
    if send_notify_flag == 1: # need send flag
        basic_class.mylogger_record.debug('Need send notify messages.')
        with open(summarypath+'/summary.log') as file3_obj:
            lines = file3_obj.readlines()   
        for line in lines:
            if '[FAIL]' in line:
                failed_testcases.append(line.strip())
        basic_class.mylogger_record.debug('failed_testcases: '+str(failed_testcases))        
        
        if len(failed_testcases) == 0: # no failed case
            basic_class.mylogger_record.debug('All testcases passed') 
            messagebody = '-----Test statistics for '+str(owm_version)+'-----\n\nTotal testcases:'+'{}'.format(total_testcases_num+imsanity_total+imap_collider_total)+'\n'+'Passed:'+'{}'.format(passed_testcases_num+imsanity_pass+imap_collider_pass)+'\n'+'Failed:'+'{}'.format(failed_testcases_num+imsanity_fail+imap_collider_fail)+'\n\n\n\n\n\nMessage sent by 5kong test tool,please DO NOT REPLY.'
        else:                          # has failed cases
            basic_class.mylogger_record.debug('Not all testcases passed') 
            faild_cases = ''
            for failed_case in failed_testcases:
                faild_cases =  faild_cases+failed_case+'\n'
            messagebody = '-----Test statistics for '+str(owm_version)+'-----\n\nTotal testcases:'+'{}'.format(total_testcases_num+imsanity_total+imap_collider_total)+'\n'+'Passed:'+'{}'.format(passed_testcases_num+imsanity_pass+imap_collider_pass)+'\n'+'Failed:'+'{}'.format(failed_testcases_num+imsanity_fail+imap_collider_fail)+'\n'+'\nFailed cases:\n\n'+faild_cases+'\n\n\n\n\n\nMessage sent by 5kong test tool,please DO NOT REPLY.'
        time.sleep(10)
        smtp_operations.send_notify(subject='MX auto tests result for {}'.format(owm_version),body=messagebody,attachment_name='test_result.txt',attachment_data=''.join(lines))
    else: # no need send notify
        basic_class.mylogger_record.debug('No need send notify messages.')    


def add_run_time():
    """add testcase costs time for each testcase"""
    
    import global_variables
    import datetime
    
    testcase_stoptime = global_variables.get_value('testcase_stoptime')
    testcase_starttime = global_variables.get_value('testcase_starttime')
    print('testcase_starttime= '+str(testcase_starttime))
    print('testcase_stoptime= '+str(testcase_stoptime))
    testcases_cost_time = (testcase_stoptime - testcase_starttime).seconds  
    print('testcases_cost_time='+str(testcases_cost_time))
    
              	