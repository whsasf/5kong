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
from threading import Thread

# user defined functions
import sys
import os.path

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
import testaid

class MSSPerfCryptoTestCase(testaid.LoggedTestCase):
    def MyThread1(self, msURL, uuidInbox):
        # perf test
        for count in xrange (1, 100):
            response = testaid.RmeTest().createMessage(msURL, uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq'])
            self.assertIsNotNone(response, 'check rmetest execution status')
            self.messageUUID = response[1]

    def MyThread2(self, msURL, uuidInbox):
        for count in xrange (1, 100):
            response = testaid.RmeTest().createMessage(msURL, uuidInbox, '/opt/imail/testaid/messages/simple_message.txt', ['-iq'])
            self.assertIsNotNone(response, 'check rmetest execution status')
            self.messageUUID = response[1]

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
        testaid.deleteMs(testaid.getMailboxIDFromMsURL(self.msURL2))

        self.logTearDown()

    def test_testMSSPerfCrypto(self):

        rmetest = testaid.RmeTest()

        ## create a new standard Mailbox 1
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

        ## create a new standard Mailbox 2
        self.msURL2 = testaid.getNextFreeMsURL()
        self.logger.info("Creating mailbox " + self.msURL2)
        response = testaid.createMs(testaid.getMailboxIDFromMsURL(self.msURL2))
        self.assertTrue(response == 1, 'create mailbox')

        rmetest.run(["mss_sl_mailboxinfo", self.msURL2])
        folderInfos = rmetest.getResponseJson()['folderInfos']
        for folderInfo in folderInfos:
            folderName = folderInfo['folderName']
            if folderName == "INBOX":
                self.uuidInbox2 = folderInfo['folderUUID']
                self.logger.info("folder INBOX = " + self.uuidInbox2)

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

        # run message creation with two threads
        perfTimePlainStart = time.time()
        thread1 = Thread(target = self.MyThread1, args = (self.msURL, self.uuidInbox))
        thread1.start()
        thread2 = Thread(target = self.MyThread2, args = (self.msURL2, self.uuidInbox2))
        thread2.start()
        thread1.join()
        thread2.join()
        perfTimePlainEnd = time.time()
        self.logger.info("Plain Time: %d" % (perfTimePlainEnd - perfTimePlainStart)) 
        self.logger.info("without encryption thread1 END")
        self.logger.info("without encryption thread2 END")

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

        # run again message creation with two threads
        perfTimeEncStart = time.time()
        thread1 = Thread(target = self.MyThread1, args = (self.msURL, self.uuidInbox))
        thread1.start()
        thread2 = Thread(target = self.MyThread2, args = (self.msURL2, self.uuidInbox2))
        thread2.start()
        thread1.join()
        thread2.join()
        perfTimeEncEnd = time.time()
        self.logger.info("Enc Time: %d" % (perfTimeEncEnd - perfTimeEncStart)) 
        self.logger.info("with encryption thread1 END")
        self.logger.info("with encryption thread2 END")

        # check on encryption performance
        self.assertTrue((perfTimeEncEnd - perfTimeEncStart) <= (perfTimePlainEnd - perfTimePlainStart) + 1, 'check that message creation is in the expected range')

        # get buffer to verify in DB
        file = open("/opt/imail/testaid/messages/simple_message.txt", "r") 
        msgSource = file.read() 
        file.close() 

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

        # retrieve message body 
        rv, data = M.fetch(100, '(rfc822)')
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

        # IMAP get the encrypted buffer and compare with the original message text
        M = imaplib.IMAP4('localhost',143)
        try:
            M.login(testaid.getMailboxIDFromMsURL(self.msURL2),'p')
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

        # retrieve message body 
        rv, data = M.fetch(100, '(rfc822)')
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