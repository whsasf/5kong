#!/usr/bin/env python3

### Test Case: MSS message creation with message body encryption ###
### Test Pre-requisite: Create Mailbox & Create Message ###


import unittest
import time
import json
import logging
import subprocess
import re
import unicodedata
import smtplib
import imaplib
import email
import email.message

# user defined functions
import sys
import os.path

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
import testaid

class MSSCryptoTestCase(testaid.LoggedTestCase):
    def hex2str(self, chain):
        return chain[2:].decode('hex')

    def is_running(self, process):
        s = subprocess.check_output(["ps", "-aef"])
        self.logger.info("examining process: " + s.lower())
        if s.lower().find(process.lower()) != -1:
            self.logger.info("process: " + process + " FOUND")
            return True
        self.logger.info("process: " + process + " NOT FOUND")
        return False

    def setUp(self):
        self.logSetUp()

        self.logger.info("Finding the first free mailbox ID...")
        ## Step 1: get a free Mailbox ID
        self.msURL = testaid.getNextFreeMsURL()

    def tearDown(self):
        ## Step 5: delete the Mailbox here to ensure deletion even in case of errors
        self.logger.info("Deleting the created mailboxes")
        testaid.deleteMs(testaid.getMailboxIDFromMsURL(self.msURL))

        self.logTearDown()

    def test_testMSSCrypto(self):

        rmetest = testaid.RmeTest()

        ## create a new standard Mailbox (sender)
        self.logger.info("Creating mailbox " + self.msURL)
        response = testaid.createMs(testaid.getMailboxIDFromMsURL(self.msURL))
        self.assertTrue(response == 1, 'create mailbox')

        rmetest.run(["mss_sl_mailboxinfo", self.msURL])
        folderInfos = rmetest.getResponseJson()['folderInfos']
        for folderInfo in folderInfos:
            folderName = folderInfo['folderName']
            if folderName == "INBOX":
                self.uuidInbox = folderInfo['folderUUID']
                self.logger.info("folder INBOX = " + self.uuidInbox)

        ## disable encryption 
        self.logger.info("Stopping MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "stop", "mss"])
        while(self.is_running('lib/mss')):
            time.sleep(1)

        messageBodyEncryptionKey = "/*/mss/messageBodyEncryptionEnabled=false"
        subprocess.check_output([testaid.IM_CONF_CTRL_CMD, "-install",  "-key",  messageBodyEncryptionKey])

        self.logger.info("Starting MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "start",  "mss"])
        while(not self.is_running("lib/mss")):
            time.sleep(1)    

        # create new message
        response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq'])
        while(not rmetest.isSuccess()):
            time.sleep(1)
            response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq']) 
        self.messageUUID = response[1]   

        # check DB
        cfmsglocalkey = self.messageUUID.replace('-', '')
        query = "select column1, value from \"KeyspaceBlobStore\".\"CF_Message_0\" where key = 0x%s;" % (cfmsglocalkey)
        self.logger.info("Executing Cql query: " + query);
        queryRes = subprocess.check_output([testaid.CQLSH_CMD, "-e", query])
        self.logger.info("Cql query result:\n" + queryRes)
        # get the number of records
        lines = queryRes.split("\n")[3:-3]
        self.logger.info("Cql query result: " + str(lines))
        self.assertTrue(len(lines) == 7, 'Query CF_Message_0 for messageUUID: %s' % self.messageUUID)

        # compression_algo_version
        cqlValue = lines[4].split("|")[0]
        cqlValue = cqlValue.strip()
        expectedValue = "4"
        self.assertTrue(cqlValue == expectedValue, 'check that compression_algo cqlValue==4')
        cqlValue = lines[4].split("|")[1]
        cqlValue = cqlValue.strip()
        expectedValue = "0x" # no compression
        self.logger.info("Cql[4][1] query value: " + cqlValue + " Expected value: " + expectedValue)
        self.assertTrue(cqlValue == expectedValue, 'check that compression_algo cqlValue==0x')

        # check that encrypt flag is not set
        cqlValue = lines[5].split("|")[0]
        cqlValue = cqlValue.strip()
        expectedValue = "7"
        self.assertTrue(cqlValue == expectedValue, 'check that encrypt flag cqlValue==7')
        cqlValue = lines[5].split("|")[1]
        cqlValue = cqlValue.strip()
        expectedValue = "0x" # no encryption
        self.logger.info("Cql[5][1] query value: " + cqlValue + " Expected value: " + expectedValue)
        self.assertTrue(cqlValue == expectedValue, 'check that encrypt flag ==0x')

        # get buffer to verify in DB
        file = open("/opt/imail/testaid/messages/simple_message.txt", "r") 
        msgSource = file.read() 
        file.close() 

        # check blob
        cqlValue = lines[6].split("|")[1]
        SIZE_PLAIN = len(cqlValue)
        cqlValue = cqlValue.strip()
        plainText = self.hex2str(cqlValue)
        plainText = plainText.replace('\r', '').replace('\n', '')
        msgSource = msgSource.replace('\r', '').replace('\n', '')
        plainText = plainText[-len(msgSource):]
        found = plainText == msgSource
        self.logger.info("Cql[6][1] query value: " + plainText + " Expected value: " + msgSource)
        self.assertTrue(found == True, 'check that message blob matches input file')

        # IMAP get the plain text buffer and compare with the original message text
        M = imaplib.IMAP4('localhost',143)
        try:
            M.login(testaid.getMailboxIDFromMsURL(self.msURL),'p')
        except:
            self.logger.info ("M.login FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'M.login FAILED...')

        try:
            self.logger.info ("SELECT INBOX...")
            rv, data = M.select("INBOX")
            self.assertEqual('OK', rv, 'SELECT INBOX must be OK')
        except:
            self.logger.info ("SELECT INBOX FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'SELECT INBOX FAILED...')

        self.logger.info ("SELECT INBOX - data:")
        self.logger.info (data)
        self.assertEqual(['2'], data, 'SELECT INBOX data must match expected value')

        # retrieve message body of last mgs (encrypted)
        rv, data = M.fetch(2, '(rfc822)')
        self.assertEqual('OK', rv, 'fetch rfc822 must be OK')
        self.logger.info (data)

        imapMsg = data[0][1]
        imapMsg = imapMsg.strip()
        imapMsg = imapMsg.replace('\r', '').replace('\n', '')
        msgSource = msgSource.strip()
        msgSource = msgSource.replace('\r', '').replace('\n', '')
        found = imapMsg == msgSource
        self.logger.info("IMAP SELECT value: " + imapMsg + " Expected value: " + msgSource)
        self.assertTrue(found == True, 'check that IMAP message matches input file')

        ## enable encryption and execute again the test expecting failure
        self.logger.info("Stopping MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "stop", "mss"])
        while(self.is_running('lib/mss')):
            time.sleep(1)

        messageBodyEncryptionKey = "/*/mss/messageBodyEncryptionEnabled=true"
        subprocess.check_output([testaid.IM_CONF_CTRL_CMD, "-install",  "-key",  messageBodyEncryptionKey])

        self.logger.info("Starting MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "start",  "mss"])
        while(not self.is_running("lib/mss")):
            time.sleep(1)    

        # create new message
        response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq'])
        while(not rmetest.isSuccess()):
            time.sleep(1)
            response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq']) 
        self.messageUUID = response[1]

        # verify DB
        cfmsglocalkey = self.messageUUID.replace('-', '')
        query = "select column1, value from \"KeyspaceBlobStore\".\"CF_Message_0\" where key = 0x%s;" % (cfmsglocalkey)
        self.logger.info("Executing Cql query: " + query);
        queryRes = subprocess.check_output([testaid.CQLSH_CMD, "-e", query])
        self.logger.info("Cql query result:\n" + queryRes)
        # get the number of records
        lines = queryRes.split("\n")[3:-3]
        self.logger.info("Cql query result: " + str(lines))
        self.assertTrue(len(lines) == 7, 'Query CF_Message_0 for messageUUID: %s' % self.messageUUID)
 
        # check that encrypt flag is set
        cqlValue = lines[5].split("|")[0]
        cqlValue = cqlValue.strip()
        expectedValue = "7"
        self.assertTrue(cqlValue == expectedValue, 'check that encrypt flag cqlValue==7')
        cqlValue = lines[5].split("|")[1]
        cqlValue = cqlValue.strip()
        expectedValue = "0x31" # no encryption
        self.logger.info("Cql[5][1] query value: " + cqlValue + " Expected value: " + expectedValue)
        self.assertTrue(cqlValue == expectedValue, 'check that encrypt flag ==0x31')

        # check that the blob in encrypted
        cqlValue = lines[6].split("|")[1]
        SIZE_ENCRYPTED = len(cqlValue)
        cqlValue = cqlValue.strip()
        plainText = self.hex2str(cqlValue)
        plainText = plainText.replace('\r', '').replace('\n', '')
        msgSource = msgSource.replace('\r', '').replace('\n', '')
        plainText = plainText[-len(msgSource):]
        found = plainText == msgSource
        self.logger.info("Cql[5][1] query value: " + plainText + " Expected value: " + msgSource)
        self.assertTrue(found != True, 'check that message blob matches input file')

        # IMAP get the encrypted buffer and compare with the original message text
        M = imaplib.IMAP4('localhost',143)
        try:
            M.login(testaid.getMailboxIDFromMsURL(self.msURL),'p')
        except:
            self.logger.info ("M.login FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'M.login FAILED...')

        try:
            self.logger.info ("SELECT INBOX...")
            rv, data = M.select("INBOX")
            self.assertEqual('OK', rv, 'SELECT INBOX must be OK')
        except:
            self.logger.info ("SELECT INBOX FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'SELECT INBOX FAILED...')

        self.logger.info ("SELECT INBOX - data:")
        self.logger.info (data)
        self.assertEqual(['3'], data, 'SELECT INBOX data must match expected value')

        # retrieve message body of last mgs (encrypted)
        rv, data = M.fetch(3, '(rfc822)')
        self.assertEqual('OK', rv, 'fetch rfc822 must be OK')
        self.logger.info (data)

        imapMsg = data[0][1]
        imapMsg = imapMsg.strip()
        imapMsg = imapMsg.replace('\r', '').replace('\n', '')
        msgSource = msgSource.strip()
        msgSource = msgSource.replace('\r', '').replace('\n', '')
        found = imapMsg == msgSource
        self.logger.info("IMAP SELECT value: " + imapMsg + " Expected value: " + msgSource)
        self.assertTrue(found == True, 'check that IMAP message matches input file')

        # retrieve message body of last mgs (plain)
        rv, data = M.fetch(2, '(rfc822)')
        self.assertEqual('OK', rv, 'fetch rfc822 must be OK')
        self.logger.info (data)

        imapMsg = data[0][1]
        imapMsg = imapMsg.strip()
        imapMsg = imapMsg.replace('\r', '').replace('\n', '')
        found = imapMsg == msgSource
        self.logger.info("IMAP SELECT value: " + imapMsg + " Expected value: " + msgSource)
        self.assertTrue(found == True, 'check that IMAP message matches input file')

        ## enable compression and execute again the test expecting failure
        self.logger.info("Stopping MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "stop", "mss"])
        while(self.is_running('lib/mss')):
            time.sleep(1)

        compressionEnabledKey = "/*/mss/compressionEnabled=true"
        subprocess.check_output([testaid.IM_CONF_CTRL_CMD, "-install",  "-key", compressionEnabledKey])

        self.logger.info("Starting MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "start",  "mss"])
        while(not self.is_running("lib/mss")):
            time.sleep(1)    

        # create new message
        response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq'])
        while(not rmetest.isSuccess()):
            time.sleep(1)
            response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq']) 
        self.messageUUID = response[1]

        # verify DB
        cfmsglocalkey = self.messageUUID.replace('-', '')
        query = "select column1, value from \"KeyspaceBlobStore\".\"CF_Message_0\" where key = 0x%s;" % (cfmsglocalkey)
        self.logger.info("Executing Cql query: " + query);
        queryRes = subprocess.check_output([testaid.CQLSH_CMD, "-e", query])
        self.logger.info("Cql query result:\n" + queryRes)
        # get the number of records
        lines = queryRes.split("\n")[3:-3]
        self.logger.info("Cql query result: " + str(lines))
        self.assertTrue(len(lines) == 7, 'Query CF_Message_0 for messageUUID: %s' % self.messageUUID)

        # compression_algo_version
        cqlValue = lines[4].split("|")[0]
        cqlValue = cqlValue.strip()
        expectedValue = "4"
        self.assertTrue(cqlValue == expectedValue, 'check that compression_algo cqlValue==4')
        cqlValue = lines[4].split("|")[1]
        cqlValue = cqlValue.strip()
        expectedValue = "0x517569636b4c5a5f312e352e30" # QuickLZ_1.5.0
        self.logger.info("Cql[4][1] query value: " + cqlValue + " Expected value: " + expectedValue)
        self.assertTrue(cqlValue == expectedValue, 'check that compression_algo cqlValue==0x517569636b4c5a5f312e352e30')

        # check that encrypt flag is set
        cqlValue = lines[5].split("|")[0]
        cqlValue = cqlValue.strip()
        expectedValue = "7"
        self.assertTrue(cqlValue == expectedValue, 'check that encrypt flag cqlValue==7')
        cqlValue = lines[5].split("|")[1]
        cqlValue = cqlValue.strip()
        expectedValue = "0x31" # no encryption
        self.logger.info("Cql[5][1] query value: " + cqlValue + " Expected value: " + expectedValue)
        self.assertTrue(cqlValue == expectedValue, 'check that encrypt flag ==0x31')

        # check that the blob in encrypted and compressed
        cqlValue = lines[6].split("|")[1]
        SIZE_ENCRYPTED_COMPRESSED = len(cqlValue)

        # IMAP get the encrypted buffer and compare with the original message text
        M = imaplib.IMAP4('localhost',143)
        try:
            M.login(testaid.getMailboxIDFromMsURL(self.msURL),'p')
        except:
            self.logger.info ("M.login FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'M.login FAILED...')

        try:
            self.logger.info ("SELECT INBOX...")
            rv, data = M.select("INBOX")
            self.assertEqual('OK', rv, 'SELECT INBOX must be OK')
        except:
            self.logger.info ("SELECT INBOX FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'SELECT INBOX FAILED...')

        self.logger.info ("SELECT INBOX - data:")
        self.logger.info (data)
        self.assertEqual(['4'], data, 'SELECT INBOX data must match expected value')

        # retrieve message body of last mgs (encrypted)
        rv, data = M.fetch(4, '(rfc822)')
        self.assertEqual('OK', rv, 'fetch rfc822 must be OK')
        self.logger.info (data)

        imapMsg = data[0][1]
        imapMsg = imapMsg.strip()
        imapMsg = imapMsg.replace('\r', '').replace('\n', '')
        msgSource = msgSource.strip()
        msgSource = msgSource.replace('\r', '').replace('\n', '')
        found = imapMsg == msgSource
        self.logger.info("IMAP SELECT value: " + imapMsg + " Expected value: " + msgSource)
        self.assertTrue(found == True, 'check that IMAP message matches input file')


        ## disable encryption and execute again 
        self.logger.info("Stopping MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "stop", "mss"])
        while(self.is_running('lib/mss')):
            time.sleep(1)

        messageBodyEncryptionKey = "/*/mss/messageBodyEncryptionEnabled=false"
        subprocess.check_output([testaid.IM_CONF_CTRL_CMD, "-install",  "-key",  messageBodyEncryptionKey])

        self.logger.info("Starting MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "start",  "mss"])
        while(not self.is_running("lib/mss")):
            time.sleep(1)    

        # create new message
        response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq'])
        while(not rmetest.isSuccess()):
            time.sleep(1)
            response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq']) 
        self.messageUUID = response[1]

        # verify DB
        cfmsglocalkey = self.messageUUID.replace('-', '')
        query = "select column1, value from \"KeyspaceBlobStore\".\"CF_Message_0\" where key = 0x%s;" % (cfmsglocalkey)
        self.logger.info("Executing Cql query: " + query);
        queryRes = subprocess.check_output([testaid.CQLSH_CMD, "-e", query])
        self.logger.info("Cql query result:\n" + queryRes)
        # get the number of records
        lines = queryRes.split("\n")[3:-3]
        self.logger.info("Cql query result: " + str(lines))
        self.assertTrue(len(lines) == 7, 'Query CF_Message_0 for messageUUID: %s' % self.messageUUID)

        # compression_algo_version
        cqlValue = lines[4].split("|")[0]
        cqlValue = cqlValue.strip()
        expectedValue = "4"
        self.assertTrue(cqlValue == expectedValue, 'check that compression_algo cqlValue==4')
        cqlValue = lines[4].split("|")[1]
        cqlValue = cqlValue.strip()
        expectedValue = "0x517569636b4c5a5f312e352e30" # QuickLZ_1.5.0
        self.logger.info("Cql[4][1] query value: " + cqlValue + " Expected value: " + expectedValue)
        self.assertTrue(cqlValue == expectedValue, 'check that compression_algo cqlValue==0x517569636b4c5a5f312e352e30')

        # check that encrypt flag is set
        cqlValue = lines[5].split("|")[0]
        cqlValue = cqlValue.strip()
        expectedValue = "7"
        self.assertTrue(cqlValue == expectedValue, 'check that encrypt flag cqlValue==7')
        cqlValue = lines[5].split("|")[1]
        cqlValue = cqlValue.strip()
        expectedValue = "0x" # no encryption
        self.logger.info("Cql[5][1] query value: " + cqlValue + " Expected value: " + expectedValue)
        self.assertTrue(cqlValue == expectedValue, 'check that encrypt flag ==0x')

        # check that the blob in encrypted and compressed
        cqlValue = lines[6].split("|")[1]
        SIZE_COMPRESSED = len(cqlValue)

        # IMAP get the encrypted buffer and compare with the original message text
        M = imaplib.IMAP4('localhost',143)
        try:
            M.login(testaid.getMailboxIDFromMsURL(self.msURL),'p')
        except:
            self.logger.info ("M.login FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'M.login FAILED...')

        try:
            self.logger.info ("SELECT INBOX...")
            rv, data = M.select("INBOX")
            self.assertEqual('OK', rv, 'SELECT INBOX must be OK')
        except:
            self.logger.info ("SELECT INBOX FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'SELECT INBOX FAILED...')

        self.logger.info ("SELECT INBOX - data:")
        self.logger.info (data)
        self.assertEqual(['5'], data, 'SELECT INBOX data must match expected value')

        # retrieve message body of last mgs (encrypted)
        rv, data = M.fetch(5, '(rfc822)')
        self.assertEqual('OK', rv, 'fetch rfc822 must be OK')
        self.logger.info (data)

        imapMsg = data[0][1]
        imapMsg = imapMsg.strip()
        imapMsg = imapMsg.replace('\r', '').replace('\n', '')
        msgSource = msgSource.strip()
        msgSource = msgSource.replace('\r', '').replace('\n', '')
        found = imapMsg == msgSource
        self.logger.info("IMAP SELECT value: " + imapMsg + " Expected value: " + msgSource)
        self.assertTrue(found == True, 'check that IMAP message matches input file')

        #check on msg size
        self.logger.info("SIZE_PLAIN: %d, SIZE_ENCRYPTED: %d, SIZE_ENCRYPTED_COMPRESSED: %d, SIZE_COMPRESSED: %d" % (SIZE_PLAIN , SIZE_ENCRYPTED, SIZE_ENCRYPTED_COMPRESSED, SIZE_COMPRESSED))
        self.assertTrue(SIZE_ENCRYPTED > SIZE_PLAIN > SIZE_ENCRYPTED_COMPRESSED > SIZE_COMPRESSED, 'check that message size is in the expected range')

        ## disable encryption and execute again to verify that encrypted message is still accessible
        self.logger.info("Stopping MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "stop", "mss"])
        while(self.is_running('lib/mss')):
            time.sleep(1)

        messageBodyEncryptionKey = "/*/mss/messageBodyEncryptionEnabled=false"
        subprocess.check_output([testaid.IM_CONF_CTRL_CMD, "-install",  "-key",  messageBodyEncryptionKey])

        self.logger.info("Starting MSS...")
        subprocess.check_output([testaid.IM_SERV_CTRL_CMD, "start",  "mss"])
        while(not self.is_running("lib/mss")):
            time.sleep(1)    

        # create new message
        response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq'])
        while(not rmetest.isSuccess()):
            time.sleep(1)
            response = rmetest.createMessage(self.msURL, self.uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq']) 
        self.messageUUID = response[1]

                # IMAP get the encrypted buffer and compare with the original message text
        M = imaplib.IMAP4('localhost',143)
        try:
            M.login(testaid.getMailboxIDFromMsURL(self.msURL),'p')
        except:
            self.logger.info ("M.login FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'M.login FAILED...')

        try:
            self.logger.info ("SELECT INBOX...")
            rv, data = M.select("INBOX")
            self.assertEqual('OK', rv, 'SELECT INBOX must be OK')
        except:
            self.logger.info ("SELECT INBOX FAILED...")
            # Force a failing assert
            self.assertEqual('OK', 'NOK', 'SELECT INBOX FAILED...')

        self.logger.info ("SELECT INBOX - data:")
        self.logger.info (data)
        self.assertEqual(['6'], data, 'SELECT INBOX data must match expected value')

        # retrieve message body of last mgs (encrypted)
        rv, data = M.fetch(5, '(rfc822)')
        self.assertEqual('OK', rv, 'fetch rfc822 must be OK')
        self.logger.info (data)

        imapMsg = data[0][1]
        imapMsg = imapMsg.strip()
        imapMsg = imapMsg.replace('\r', '').replace('\n', '')
        msgSource = msgSource.strip()
        msgSource = msgSource.replace('\r', '').replace('\n', '')
        found = imapMsg == msgSource
        self.logger.info("IMAP SELECT value: " + imapMsg + " Expected value: " + msgSource)
        self.assertTrue(found == True, 'check that IMAP message matches input file')

if __name__ == '__main__':
    unittest.main()