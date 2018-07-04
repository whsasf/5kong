#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

def decrypt_aes(mode,key,iv,data_to_decrypt):
    """thsi function is used to decypt the data that encrypted using AES"""
    
    from Crypto.Cipher import AES
    from binascii import b2a_hex, a2b_hex
    import basic_class
        
    # decide which mode to use 
    if 'cbc' in mode.lower():
        decryption_mode = AES.MODE_CBC
        #neediv = True
    elif 'ecb' in mode.lower():
        decryption_mode = AES.MODE_ECB
        #neediv = False
    elif 'cfb' in mode.lower():
        decryption_mode = AES.MODE_CFB
    elif 'ofb' in mode.lower():
        decryption_mode = AES.MODE_OFB
    elif 'ctr' in mode.lower():
        decryption_mode = AES.MODE_CTR
    else:
        pass
           
    basic_class.mylogger_record.debug('key:')
    basic_class.mylogger_recordnf.debug(key[0])
    basic_class.mylogger_record.debug('decryption_mode:')
    basic_class.mylogger_recordnf.debug(decryption_mode)
    basic_class.mylogger_record.debug('iv:')
    basic_class.mylogger_recordnf.debug(iv[0]) 
    if  'ecb' in mode.lower():
        cipher = AES.new(key[0],decryption_mode)
    else:
        cipher = AES.new(key[0],decryption_mode,iv[0])   
    data_after_decrypt = cipher.decrypt(data_to_decrypt)
    basic_class.mylogger_record.debug('the raw message data after decryption is:')
    basic_class.mylogger_recordnf.debug(data_after_decrypt)
    return data_after_decrypt
    