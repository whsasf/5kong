#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

import basic_class
import requests
import json

def fetch_latest_message_uuid(mxos_host,mxos_port,account,folder='inbox'):
    """this function is used to fetch the uuid latest message"""
    
    uuids=requests.get('http://{0}:{1}/mxos/mailbox/v2/{2}/folders/{3}/messages/metadata/uuid/list'.format(mxos_host,mxos_port,account,folder))
    basic_class.mylogger_record.debug('uuids:')
    basic_class.mylogger_recordnf.debug(str(uuids)+':'+str(uuids.text))
    
    if '200' in  str(uuids):
        if uuids.text.replace('[]',''):     # has messages
            uuid = (uuids.text.split('"')[-2]).replace('-','')
            basic_class.mylogger_record.debug('last message uuid:')
            basic_class.mylogger_recordnf.debug(uuid)
            return uuid
        else:                               # no messages
            basic_class.mylogger_record.warning('no messages in folder')
    else:
        basic_class.mylogger_record.warning('fetch messages uuid faild!!')
        


 
                
        
        
def fetch_first_message_uuid(mxos_host,mxos_port,account,folder='inbox'):
    """this function is used to fetch the uuid first message"""
    
    uuids=requests.get('http://{0}:{1}/mxos/mailbox/v2/{2}/folders/{3}/messages/metadata/uuid/list'.format(mxos_host,mxos_port,account,folder))
    basic_class.mylogger_record.debug('uuids:')
    basic_class.mylogger_recordnf.debug(str(uuids)+':'+str(uuids.text))
    
    if '200' in  str(uuids):
        if uuids.text.replace('[]',''):     # has messages
            uuid = (uuids.text.split('"')[1]).replace('-','')
            basic_class.mylogger_record.debug('first message uuid:')
            basic_class.mylogger_recordnf.debug(uuid)
            return uuid
        else:                               # no messages
            basic_class.mylogger_record.warning('no messages in folder')
    else:
        basic_class.mylogger_record.warning('fetch messages uuid faild!!')        

    
def fetch_current_uid_passphrase(mxos_ip,mxos_port):
    """this function is used to fetch current passphrase and uid for messagebody encryption,
        mxos API:messageBodyEncryption
    """
        
    basic_class.mylogger_record.info('fetch encryptin passphrase uid')
    fetch_current_passphrase_uid_result = requests.get('http://{0}:{1}/mxos/encryption/v2/messageBodyEncryption'.format(mxos_ip,mxos_port))
    basic_class.mylogger_record.debug('fetch_current_passphrase_uid_result:')
    basic_class.mylogger_recordnf.debug(str(fetch_current_passphrase_uid_result)+'\n'+str(fetch_current_passphrase_uid_result.text))

    if '200' in str(fetch_current_passphrase_uid_result):  # fetch success
        if fetch_current_passphrase_uid_result.text.replace('{}',''):       # already has passphrase

            currentuid = json.loads(fetch_current_passphrase_uid_result.text)["currentKey"]["uid"]
            currentpassphrase = json.loads(fetch_current_passphrase_uid_result.text)["currentKey"]["encryptionKey"]
            basic_class.mylogger_record.debug('current uid is:')
            basic_class.mylogger_recordnf.debug(str(currentuid))
            basic_class.mylogger_record.debug('current key is:')
            basic_class.mylogger_recordnf.debug(str(currentpassphrase))            
            return (str(int(currentuid)+1),str(currentpassphrase))
        else:                                              # doesn't have encryption keys                       
            basic_class.mylogger_record.info('there is no encryption key now!')
            return ('1001','0')
    else:
        basic_class.mylogger_record.warning('error happens during fetch passphrase,please check manually!')
        return ('-1','-1')


def create_passphrase(mxos_ip,mxos_port,uid,cipherName,encryptionKey):
    """this function is used to create  passphrase for messagebody encryption feycntion,
        mxos API:messageBodyEncryption
    """
   
    basic_class.mylogger_record.info('create encryptin passphrase: '+str(uid)+':'+str(cipherName)+':'+str(encryptionKey))
    create_passphrase_result = requests.post('http://{0}:{1}/mxos/encryption/v2/messageBodyEncryption'.format(mxos_ip,mxos_port), data = {'currentKey':'{}:{}:{}'.format(uid,cipherName,encryptionKey)})
    basic_class.mylogger_record.debug('create_passphrase_result:')
    basic_class.mylogger_recordnf.debug(str(create_passphrase_result))
    
    if '200' in str(create_passphrase_result): #postsuccessfully
        basic_class.mylogger_record.info('create encryptin passphrase successfully')
    else:
        basic_class.mylogger_record.warning('create encryptin passphrase unsuccessfully')    
    return create_passphrase_result
        
     