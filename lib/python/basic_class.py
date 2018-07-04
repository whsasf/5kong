# -*- coding: utf-8 -*- 
# this module contains the clacces used commenly

# import need moduels
import os        # import listdir,getcwd,chdir,system,path #used in class Directory
import logging   # import StreamHandler,FileHandler,Formatter,getLogger,info,debug,warning,error,critical #used in class Loggger

#import global_variables

class Discovery():
    """class Discovery used to traverse the testcases and run them"""   
    #def __init__(self):
    
    def traverse(self,Path):
        """ this function is used to traverse all folders and files under target path,an run specific scripts"""        
        self.Path = Path
        os.chdir(self.Path)        
        currentlists = os.listdir('.') # get current folder and file names in current path
        for list in currentlists:      # delete the hiden files and folders
            if list.startswith('.'):
                currentlists.remove(list)
        #print (currentlists)        
        if 'setup' in currentlists:            # run setup
            os.system('chmod +x setup;./setup')            
        if 'run' in currentlists:              # run run
            os.system('chmod +x run;./run')           
        for list in currentlists:
            if os.path.isdir(list):
                self.traverse(list)
                #os.chdir(list)
                #print (os.getcwd())
        if 'teardown' in currentlists:         # run teardown 
            os.system('chmod +x teardown;./teardown')
        os.chdir('..')
        
        

def find_real_funcName():
    """this function used to fidn the father level of current logging function"""
    import traceback
    import inspect    

    funcName = (traceback.format_stack(inspect.currentframe()))[-3].split(',')[2].split('\n')[0].split()[1]
    return funcName
    
    
    
class Loggger_summary():  
    """this class only only write to summary file  without format"""
    
    def __init__(self):    	
        """ definition of some"""
        self.loggerrr = logging.getLogger('WK-summary')
        self.loggerrr.setLevel(logging.INFO)  #defaut 'INFO'        
        import global_variables
        self.summarypath = global_variables.get_value('summarypath')
        self.fh = logging.FileHandler(self.summarypath+'/summary.log')
        self.fh.setLevel(logging.DEBUG)
        self.formatter = logging.Formatter('%(message)s')
        self.fh.setFormatter(self.formatter)
        self.loggerrr.addHandler(self.fh)


    def yes(self,yesmessages='this test case passed'):
        self.loggerrr.info(yesmessages)

    def no(self,nomessages='this test case failed'):
        self.loggerrr.info(nomessages)
                
            
                        

class Loggger_record():     
    """this is a class for logging any records to screen and log files with format"""
    
    def __init__(self,chloglevel):    	
        """ definition of some"""
        self.logger = logging.getLogger('WK-record')
        self.logger.setLevel(logging.DEBUG)  #defaut 'DEBUG'
        self.chloglevel = chloglevel        
        self.ch = logging.StreamHandler()
        #get chloglevel from outside
        if 'WARNING' in self.chloglevel:
            self.ch.setLevel(logging.DEBUG)# "-v" or '-vv' will both display DEBUG information
        elif 'DEBUG' in self.chloglevel:
            self.ch.setLevel(logging.DEBUG)
        else:
            self.ch.setLevel(logging.INFO) #default 'INFO'
        #self.ch.setLevel(logging.ERROR)        
        #initialpath = global_variables.get_value('initialpath')
        #print('initialpath='+initialpath)
        import global_variables
        self.logpath = global_variables.get_value('logpath')
        self.fh = logging.FileHandler(self.logpath+'/alltestcases.log')
        self.fh.setLevel(logging.DEBUG)
        self.formatter = logging.Formatter('[%(asctime)s] [%(levelname)s] %(message)s')
        self.ch.setFormatter(self.formatter)
        self.fh.setFormatter(self.formatter)
        self.logger.addHandler(self.ch)
        self.logger.addHandler(self.fh)
        
    def debug(self,debugmessages='this is debug message'): 
        funcName = find_real_funcName()  
        self.logger.debug('[{}] '.format(funcName)+'\033[1;33m'+str(debugmessages)+'\033[0m')

    def info(self,infomessages='this is info message'):
        funcName = find_real_funcName()
        self.logger.info('[{}] '.format(funcName)+infomessages)

    def warning(self,warnmessages='this is warn message'):
        funcName = find_real_funcName()
        self.logger.warn('[{}] '.format(funcName)+'\033[1;31m'+warnmessages+'\033[0m')

    def error(self,errormessages='this is error message'):    
        funcName = find_real_funcName()
        self.logger.error('[{}] '.format(funcName)+'\033[1;31m'+errormessages+'\033[0m')

    def critical(self,criticalmessages='this is critical message'):    
        funcName = find_real_funcName()
        self.logger.critical('[{}] '.format(funcName)+'\033[1;31m'+criticalmessages+'\033[0m')

    def yes(self,yesmessages='this is yes message'):
        funcName = find_real_funcName()
        self.logger.info('[{}] '.format(funcName)+'\033[1;32m'+yesmessages+'\033[0m')

    def no(self,nomessages='this is no message'):
        funcName = find_real_funcName()
        self.logger.info('[{}] '.format(funcName)+'\033[1;31m'+nomessages+'\033[0m')        
        

class Loggger_record_noformat():
    """this is a class for logging any records to screen and log files without format"""
    
    def __init__(self,chloglevel):    	
        """ definition of some"""
        self.logger = logging.getLogger('WK-record_title')
        self.logger.setLevel(logging.DEBUG)  #defaut 'DEBUG'
        self.chloglevel = chloglevel        
        self.ch = logging.StreamHandler()
        #get chloglevel from outside
        if 'WARNING' in self.chloglevel:
            self.ch.setLevel(logging.DEBUG)# "-v" or '-vv' will both display DEBUG information
        elif 'DEBUG' in self.chloglevel:
            self.ch.setLevel(logging.DEBUG)
        else:
            self.ch.setLevel(logging.INFO) #default 'INFO'
        #self.ch.setLevel(logging.ERROR)        
        #initialpath = global_variables.get_value('initialpath')
        #print('initialpath='+initialpath)
        import global_variables
        self.logpath = global_variables.get_value('logpath')
        self.fh = logging.FileHandler(self.logpath+'/alltestcases.log')
        self.fh.setLevel(logging.DEBUG)
        self.formatter = logging.Formatter('%(message)s')
        self.ch.setFormatter(self.formatter)
        self.fh.setFormatter(self.formatter)
        self.logger.addHandler(self.ch)
        self.logger.addHandler(self.fh)
        
    def debug(self,debugmessages='this is debug message'):   
        self.logger.debug('\033[1;33m'+str(debugmessages)+'\033[0m')
        
    def info(self,infomessages='this is info message'):
        self.logger.info(infomessages)

    def warning(self,warnmessages='this is warn message'):
        self.logger.warn('\033[1;31m'+warnmessages+'\033[0m')

    def error(self,errormessages='this is error message'):    
        self.logger.error('\033[1;31m'+errormessages+'\033[0m')

    def critical(self,criticalmessages='this is critical message'):    
        self.logger.critical('\033[1;31m'+criticalmessages+'\033[0m')
        
    def title(self,titlemessages='this is title message'):
        self.logger.info('\033[1;36m'+titlemessages+'\033[0m')        

    def yes(self,yesmessages='this is yes message'):
        self.logger.info('\033[1;32m'+yesmessages+'\033[0m')

    def no(self,nomessages='this is no message'):
        self.logger.info('\033[1;31m'+nomessages+'\033[0m')          
if True:
    from basic_function import parse_chloglevel
    
    chloglevel = parse_chloglevel() 
    
    mylogger_summary  = Loggger_summary()                    # example: basic_class.mylogger_summary.yes('yes')
#   mylogger_title    = Loggger_title()                      # example: basic_class.mylogger_title.info('step1')    
    mylogger_record   = Loggger_record(chloglevel)           # example: basic_class.mylogger_record.info('step1')
    mylogger_recordnf = Loggger_record_noformat(chloglevel)  # example: basic_class.mylogger_recordcf.info('step1')


 

