#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

def setlibpath():   
    """setlibpath function add lib folder to sys.path for modules search"""
    
    import os
    import sys
    #import pprint

    print('\n')
    #print('\033[1;36m=\033[0m'*68)
    #print('\033[1;36m='+"{:^66}".format('5Kong Test Suit')+'=\033[0m')
    #print('\033[1;36m=\033[0m'*68)
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~') 
    print('|     ___________   _____   ______   _____      _____     _____      ________             |') 
    print('|    /         _/  /    /  /     /  /     \     |    |   /    |     /       /             |') 
    print('|    $$$$$$$$$$|   $$$ /   $$$$$_| /$$$$$$ \     $$ |      $$ |     $$$$$$$ |             |') 
    print('|    $$ |          $$ |   $$ /     $$ ____$ \    $$ |    $$$$ |   $$  /----               |') 
    print('|    $$  -----\    $$ |__$$ /     $$ /    $$ \   $$ |   $  $$ |  $$  /  /------|          |') 
    print('|    $$$$$$$$  \   $$$$$$$ /     $$ /      $$ |  $$ |  $ __$$ | $$  |   $$$$$ _|          |') 
    print('|           $$  \  $$ |-$$\     $$ |       $$ /  $$ | $ /  $$ |  $$  \____$$ |            |') 
    print('|            $$ |  $$ |  $$ \    $$ \____  $ /   $$ |$ /   $$ |   $$      $$ |            |') 
    print('|    $      $$  /  $$ |   $$$ \__ $$     $$ /    $$$$ /    $$ |     $$$$$$$$ |            |') 
    print('|   / $$$$$$$  /  $$$$|   $$$$$$ \  $$$$$$ /     $$  /     $$ |           $$ |            |') 
    print('|   \---------/   \___|    \_____/   -----/     |___/      |__/           |__/  TEST Tool |') 
    print('|                                                                               FOR MX QA |') 
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~') 
                  
    # print title to indicate begin running all testcases
    print('\033[1;36m\n[[Section 1: Prepare all prerequisite ... ]]\033[0m')
        
    global initialpath
    initialpath = os.getcwd()              # get initial path and return at last
    initial_libpath = initialpath+'/lib'
    
    def traverse_lib(libpath):
        """traverse customer libpath"""
        
        tmp_lists = []                     # store temp sub-folders and files  lists
        customer_libpath = []              # store specific sub-dolders lists
        os.chdir(libpath)                  # switch to current Path
        
        tmp_lists = os.listdir('.')        # get current folder and file names under current path
        for tmp in tmp_lists:              # delete the hiden files and folders
            if tmp.startswith('.'):
                tmp_lists.remove(tmp)
        for tmp in tmp_lists:              # delete the '__pycache__/' folderss
            if '__pycache__' in tmp:
                tmp_lists.remove(tmp)
        
        if tmp_lists != []:                # if this is the upmost level. pass
            for tmp in tmp_lists:
                if os.path.isdir(tmp):
                    customer_libpath.append(os.path.abspath(tmp))
        else:
            os.chdir('..')
        if customer_libpath:
            for list in customer_libpath:
                sys.path.append(list)
                traverse_lib(list)        
    
    traverse_lib(initial_libpath)          # invoke traverse_lib function
    #pprint.pprint(sys.path)
    
    os.chdir(initialpath)                  # backs to the original home path after find all customized lib paths
    
    return initialpath                     # return origin home path for later use