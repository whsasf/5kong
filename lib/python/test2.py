#!/usr/bin/env python3

import logging
import traceback
import inspect

def haha(msg):
    return  hello(msg)
    
def hello(msg):
    return error(msg)
    
def error(msg):
    stack_trace = traceback.format_stack(inspect.currentframe())   
    print(stack_trace)
    funcName = stack_trace[-3].split(',')[2].split('\n')[0].split()[1]
    logging.error('[{}]'.format(funcName) + " " + msg)
    
haha('hello world')

    
    
