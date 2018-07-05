#!/usr/bin/env python3
# -*- coding: utf-8 -*-      
 
""" This Python file is the main Python run script.Created on 2018/05/16"""

# below part is used to switch 5kong main flder incase execute it from other path,we recommand to run 5kong_run.py from it's mail path
import sys,os
if sys.argv[0] == './5kong_run.py' or sys.argv[0] == '5kong_run.py':
    destpath = '.'
else:
    destpath = sys.argv[0].split('5kong_run.py')[0]
os.chdir(destpath)

initialpath = ''
import setlibpath
initialpath = setlibpath.setlibpath() #all the other modules import should after this function call,otherwise can not find correct customized lib location  
import sys
from basic_function import create_log_folders ,construct_mx_topology,variables_prepare ,welcome ,print_mx_version
variables_prepare(initialpath)  # gather pre-defined variables
create_log_folders()            # create alltestcases.log and summary.log
welcome()                       # print welcome headers 
print_mx_version()              # gather mx version,like 'mx_version = 9.5.3.0-15.el6.x86_64'

import basic_class
import basic_function          
construct_mx_topology()   # gernet and read construct topology of mx

def main():
    """main function to active logging,testcase running"""    
    
    import global_variables  
    global_variables.set_value('initialpath',initialpath)          
    testcaselocation = global_variables.get_value('argvlist')
    chloglevel = global_variables.get_value('chloglevel')   
    tclocation = basic_function.parse_testcaselocation(testcaselocation) # format testcase location in a list for given formats
   
    basic_function.execute(tclocation,initialpath) # executing testcases    
    basic_function.statistics()                    # statistics all testcases results

if __name__ == '__main__':
    main()