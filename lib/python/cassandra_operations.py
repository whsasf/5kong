#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

def cassandra_cqlsh_fetch_messagebody(blobip,blobport,messageid,decryption_flag):
    """this function used to fetch message body"""
    
    from cassandra.cluster import Cluster
    import global_variables
    import basic_class
    import encryption_decryption_related    
    import math
    
    if not blobport:
        blobport = global_variables.get_values('default_cassblob_port')[0]
        
    iv = global_variables.get_values('AES_iv')  #AES_iv
    # get passphrase value
    if decryption_flag != 0:
        encrypted_flag = 1
        basic_class.mylogger_record.debug('encrypted_flag is: '+str(encrypted_flag))
        if '128' in decryption_flag:
            passphrase = global_variables.get_values('ASE_key128')
        elif '192' in decryption_flag:
            passphrase = global_variables.get_values('ASE_key192')
        elif '256' in decryption_flag:
            passphrase = global_variables.get_values('ASE_key256')
        else:
            pass
    else:
        encrypted_flag = 0
        basic_class.mylogger_record.debug('encrypted_flag is: '+str(encrypted_flag))  # 0 means message body is not encrypted, 1 means message body encrypted
        
    try:    
        cluster = Cluster([blobip],port=blobport,connect_timeout=30)
    except:
        basic_class.mylogger_record.warning('Connect to cassamblob failed')
    session = cluster.connect('KeyspaceBlobStore')
    #session.row_factory = dict_factory
    plain_data_lists = [] # used to store the plain data,each column is one element of lists,from 101
    
    for i in range(0,20):
        target = 'select * from "CF_Message_{0}" where key=0x{1};'.format(i,messageid)
        basic_class.mylogger_record.debug('target:')
        basic_class.mylogger_recordnf.debug(target)
        
        raw_datas = session.execute(target,timeout=6000)                
        if raw_datas:
            # disable below 2 lines default, to avoid large messge display
            #basic_class.mylogger_record.debug('raw_datas stored in KeyspaceBlobStore.CF_Message_{0} is:'.format(i))
            #basic_class.mylogger_recordnf.debug(raw_datas[:])  
            
            single_blob_size = 0
            total_blob_size = 0
            blob_num = 0
            
            for raw_data in raw_datas:
                if raw_data[1] == 2: # single blob size
                    single_blob_size = raw_data[2]
                    basic_class.mylogger_record.debug('single messageblob_size is: '+str(single_blob_size.decode()))
                if raw_data[1] == 3: # total stored blob size
                    total_blob_size = raw_data[2]
                    basic_class.mylogger_record.debug('total messageblob_size is: '+str(total_blob_size.decode()))
                    blob_num = math.ceil(int(total_blob_size.decode())/int(single_blob_size.decode()))
                    basic_class.mylogger_record.debug('total messageblob_number is: '+str(blob_num))                                
                
                if raw_data[1] in range(101,101+blob_num):
                    column = raw_data[1]
                    value = raw_data[2]
                    
                    if blob_num <= 3:#do not outout each column to save time for large message.
                        basic_class.mylogger_record.debug('raw message body for column {0} is:'.format(column))
                        basic_class.mylogger_recordnf.debug(value)
                    else:
                        pass
                
                    if decryption_flag == 0:   # no need decryption first
                        basic_class.mylogger_record.info('mesage body is not encrypted')
                        plain_data = value
                    else:                      # need decrypt,raw_data[2] is contains the message body raw data                   
                        basic_class.mylogger_record.info('message body is encrypted, need decrypt first')
                        plain_data = encryption_decryption_related.decrypt_aes(decryption_flag,passphrase,iv,value)
                    
                    if blob_num  <= 3: #do not outout each column to save time for large messages.
                        basic_class.mylogger_record.debug('plain message body data is:')
                        basic_class.mylogger_recordnf.debug(plain_data) 
                    else:
                        pass
                        
                    data_format = plain_data.decode('utf-8','ignore')
                    try:
                        data_format = data_format[data_format.rindex('\x00'):]
                        data_format = data_format[:data_format.rindex('\r\n')]
                        plain_data_lists.append(data_format)
                    except ValueError:
                        basic_class.mylogger_recordnf.warning('substring not found')
                        plain_data_lists.append(data_format)
            full_messagebody = ''.join(plain_data_lists)
            if blob_num  <= 3: #do not outout each column to save time for large messages.                    
                basic_class.mylogger_record.debug('full message body is:')                
                basic_class.mylogger_recordnf.debug(full_messagebody)
            else:
                pass
            #with open("xx.txt",'w',encoding='utf8') as f:
            #    f.write(full_messagebody)
    cluster.shutdown()
    return (encrypted_flag,full_messagebody)  