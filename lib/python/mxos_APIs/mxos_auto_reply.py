#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

import basic_class
import requests
import json


def set_autoreply(mxos_host,mxos_port,account,autoReplyMode,autoReplyStartDate,autoReplyMessage="internal:%0athis is an autoreply message for internal accounts%0aexternal:%0aathis is an autoreply message for external accounts%0a",autoReplyStopDate=None):
    """this function is used to create autoreply info,
        mxos API:mailReceipt
    """
   
    basic_class.mylogger_record.info('set autoreply: '+str(autoReplyMode)+':'+str(autoReplyMode)+','+'autoReplyStartDate:'+str(autoReplyStartDate)+'autoReplyMessage:'+str(autoReplyMessage))
    set_autoreply_result = requests.post('http://{0}:{1}/mxos/mailbox/v2/{2}/mailReceipt'.format(mxos_host,mxos_port,account), data = {'autoReplyMode':'{}'.format(autoReplyMode),'autoReplyStartDate':'{}'.format(autoReplyStartDate),'autoReplyMessage':'{}'.format(autoReplyMessage)})
    basic_class.mylogger_record.debug('set_autoreply_result:')
    basic_class.mylogger_recordnf.debug(str(set_autoreply_result)+str(set_autoreply_result.text))
    
    if '200' in str(set_autoreply_result): #postsuccessfully
        basic_class.mylogger_record.info('set autoreply successfully')
    else:
        basic_class.mylogger_record.warning('set autoreply unsuccessfully')    
    return set_autoreply_result
    
    
def get_autoreply(mxos_host,mxos_port,account):
    """this function is used to get autoreply info,
        mxos API:mailReceipt
    """
   
    basic_class.mylogger_record.info('get autoreply for account:'+str(account))
    set_autoreply_result = requests.get('http://{0}:{1}/mxos/mailbox/v2/{2}/mailReceipt'.format(mxos_ip,mxos_port,account), data = {'autoReplyMode':'{}'.format(autoReplyMode),'autoReplyStartDate':'{}'.format(autoReplyStartDate),'autoReplyMessage':'{}'.format(autoReplyMessage)})
    basic_class.mylogger_record.debug('set_autoreply_result:')
    basic_class.mylogger_recordnf.debug(str(set_autoreply_result))
    
    if '200' in str(set_autoreply_result): #postsuccessfully
        basic_class.mylogger_record.info('set autoreply successfully')
    else:
        basic_class.mylogger_record.warning('set autoreply unsuccessfully')    
    return set_autoreply_result    