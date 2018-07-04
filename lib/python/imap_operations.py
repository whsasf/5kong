# -*- coding: utf-8 -*- 
# this module contains the IMAP operation related classes and functions

# import need moduels
from imaplib_customized import IMAP4,Time2Internaldate
import base64
import time
import basic_class

class IMAP_Ops(IMAP4):
    """this class defines all imap related methods"""    
    
    def __init__(self,imaphost,imapport,outcome = 0,logdata = '',imap4 = ''):
        """this init function will initiate target imap connection host and port
           example: instance = IMAP_Ops('10.49.58.239',20143)
        """        
        self.imaphost = imaphost
        self.imapport = imapport
        self.outcome = outcome    # outcome records the response code of each imap operation, like 200 means success
        self.logdata = logdata    # logdata is the data we got after executing the imap operation,usually used to verify if the operation success 
        basic_class.mylogger_record.info('<init IMAP4 instance:imap4 against >'+str(self.imaphost)+':'+str(self.imapport)) 
        self.imap4 = IMAP4(host = self.imaphost,port = self.imapport)           # instance of IMAP class
        #self.imap4_ssl = IMAP4_SSL(host = self.imaphost,port = self.imapport)  # instance of IMAP class
        
               
    def imap_login(self,loginuser,loginpass):
        """method imap_login will perform imap login operation
           example: instance.imap_login('xx1','p')
        """       
        self.loginuser = loginuser
        self.loginpass = loginpass
        basic_class.mylogger_record.info('command:<imap login '+self.loginuser+' '+self.loginpass+'>')        
        self.outcome,self.logdata = self.imap4.login(self.loginuser,self.loginpass)
        basic_class.mylogger_record.debug(self.logdata[0].decode())
        #[basic_class.mylogger_recordnf.debug(line.decode('utf-8')) for line in self.logdata]
        #self.imap4.logout()
    
    
    
    def imap_logout(self):
        """method imap_logout will perform imap logout operation
           example: instance.imap_logout()
        """
        
        basic_class.mylogger_record.info('command:<imap logout>')        
        self.outcome,self.logdata = self.imap4.logout()
        basic_class.mylogger_record.debug(self.logdata[0].decode())        
        #[basic_class.mylogger_recordnf.debug(line.decode('utf-8')) for line in self.logdata]



    def imap_select(self,mailbox = 'INBOX',readonly = False):
        """method imap_select will perform imap select operation
           example: instance.imap_select() or instance.imap_select('SentMail',True) or instance.imap_select('SentMail')
        """
        self.mailbox = mailbox     # the folder that will be selected
        self.readonly = readonly   # If the readonly flag is set, modifications to the mailbox are not allowed
        basic_class.mylogger_record.info('command:<imap select '+self.mailbox+'>')        
        self.outcome,self.logdata = self.imap4.select(mailbox = self.mailbox,readonly = self.readonly)
        basic_class.mylogger_record.debug(self.logdata[0].decode())
        #[basic_class.mylogger_recordnf.debug(line.decode('utf-8')) for line in self.logdata]
        return self.logdata[0].decode()
        #self.imap4.logout()
   

    def imap_append(self,message=b"From: me\nTo: you\nSubject: are you OK?\n\nThis world could be better!", mailbox='INBOX',flags='NEW'):
        """method used to append message in INBOX(default) and other folders
           example: instance.imap_append(message=b"From:tom\nTo:lucy\nSubject:haha\n\nffffffffffffffffffff",mailbox='Trash')
                   or instance.imap_append()
        """
        
        self.message = message
        self.mailbox = mailbox
        self.flags = flags
        datetime = time.time()
        datetime = Time2Internaldate(datetime)
        print(datetime)
        basic_class.mylogger_record.info('command:<imap append '+self.mailbox+' '+'message:\n'+self.message.decode()+'\n>')        
        self.outcome,self.logdata = self.imap4.append(mailbox=self.mailbox,flags=self.flags,date_time=datetime,message=self.message)
        basic_class.mylogger_record.debug(self.logdata[0].decode())    
        #self.imap4.logout()  


    def imap_create(self,mailbox):
        """Create new mailbox named mailbox
           example: instance.imap_create('haha2')
        """
        
        self.mailbox = mailbox
        basic_class.mylogger_record.info('command:<imap create '+self.mailbox+'>')        
        self.outcome,self.logdata = self.imap4.create(self.mailbox)
        basic_class.mylogger_record.debug(self.logdata[0].decode())    
        #self.imap4.logout() 


    def imap_list(self,directory='""',pattern='*'):
        """List mailbox names in directory matching pattern. directory defaults to the top-level mail folder,
           and pattern defaults to match anything. Returned data contains a list of LIST responses
           example:instance.imap_list()                               -->list all folders of all levels
                  or instance.imap_list(pattern='%%')                 -->only list the  folders that has 2 levels
                  or instance.imap_list(directory='haha2',pattern='%')-->list level 1 folder of haha2 directory
        """
        
        self.directory = directory
        self.pattern = pattern
        basic_class.mylogger_record.info('command:<imap list '+self.directory+' '+self.pattern+'>')        
        self.outcome,self.logdata = self.imap4.list(directory=self.directory,pattern=self.pattern)
        basic_class.mylogger_record.debug('The list command return:') 
        [basic_class.mylogger_recordnf.debug(list.decode()) for list in self.logdata]
        #self.imap4.logout() 
                        

    def imap_copy(self,message_set,new_mailbox):
        """Copy message_set messages onto end of new_mailbox from current folder
           example: instance.imap_copy('1,2','haha2')
        """
        
        self.message_set = message_set
        self.new_mailbox = new_mailbox
        basic_class.mylogger_record.info('command:<imap copy '+self.message_set+' '+self.new_mailbox+'>')        
        self.outcome,self.logdata = self.imap4.copy(self.message_set,self.new_mailbox)
        basic_class.mylogger_record.debug(self.logdata[0].decode())    
        #self.imap4.logout() 
        

    def imap_move(self,message_set,new_mailbox):
        """Move message_set messages onto end of new_mailbox from current folder
           example: instance.imap_move('1,2','haha2')
        """
        
        self.message_set = message_set
        self.new_mailbox = new_mailbox
        basic_class.mylogger_record.info('command:<imap move '+self.message_set+' '+self.new_mailbox+'>')        
        self.outcome,self.logdata = self.imap4.move(self.message_set,self.new_mailbox)
        basic_class.mylogger_record.debug(self.logdata[0].decode())
        #self.imap4.logout() 
        
            
    def imap_fetch(self,message_set, message_parts):
        """method imap_fetch will perform imap fetch operation
           example: instance.imap_fetch(1,'RFC822') or instance.imap_fetch(1:*,'body[text]')   
        """
        import email
        self.message_set = message_set
        self.message_parts = message_parts
        basic_class.mylogger_record.info('command:<imap fetch '+self.message_set+' '+self.message_parts+'>')        
        self.outcome,self.logdata = self.imap4.fetch(self.message_set, self.message_parts)
        basic_class.mylogger_record.debug('outcome= '+self.outcome)
        basic_class.mylogger_record.debug('the fetch_rsp_data is:')        
        
        fetch_content = []
        if self.outcome == 'OK':
            for line in self.logdata:
                if 'tuple' in str(type(line)):
                    for tup in line:
                        basic_class.mylogger_recordnf.debug(tup.decode('utf-8'))
                        fetch_content.append(tup.decode('utf-8'))
                else:
                    basic_class.mylogger_recordnf.debug(line.decode('utf-8'))  
                    fetch_content.append(line.decode('utf-8'))  
        else:
            for line in self.logdata:
                basic_class.mylogger_recordnf.debug(line.decode('utf-8'))
                fetch_content.append(line.decode('utf-8'))
        return fetch_content
        #self.imap4.logout()
        
    
    def imap_authenticate(self,loginuser,loginpass,mechanism = 'PLAIN'):
        """method imap_authenticate will perform imap authenticate operation,commonly used for imap plain authentication
           example: instance.imap_authenticate('xx1','p')
        """
        
        self.loginuser = loginuser
        self.loginpass = loginpass
        self.mechanism = mechanism
        basic_class.mylogger_record.info('command:<imap authenticate plain>')        
        self.authobject = lambda authobject:'\x00{0}\x00{1}'.format(self.loginuser,self.loginpass)
        basic_class.mylogger_record.debug('mechanism = '+str(self.mechanism))
        basic_class.mylogger_record.debug('authobject = '+str(self.authobject))
        self.outcome,self.logdata = self.imap4.authenticate(self.mechanism,self.authobject)
        basic_class.mylogger_record.debug(self.logdata[0].decode())
        #[basic_class.mylogger_recordnf.debug(line.decode('utf-8')) for line in self.logdata]
        #self.imap4.logout()

    def imap_auth_crammd5(self,loginuser,loginpass):
        """method imap_auth_crammd5 will perform imap cram-md5 authentication
           example: instance.imap_auth_crammd5('xx1','p')
        """
        self.loginuser = loginuser
        self.loginpass = loginpass
        basic_class.mylogger_record.info('command:<imap authenticate cram-md5>')        
        self.outcome,self.logdata = self.imap4.login_cram_md5(self.loginuser,self.loginpass)
        basic_class.mylogger_record.debug(self.logdata[0].decode())
        #[basic_class.mylogger_recordnf.debug(line.decode('utf-8')) for line in self.logdata]
        #self.imap4.logout()


 

#def imap_login(imaphost,imapport,loginuser,loginpass):           # merge create instance and imap_login
#    """method imap_login will perform imap login operation
#       example: instance.imap_login('10.49.58.239',20143,'xx1','p')
#    """    
#    myimap = IMAP_Ops(imaphost,imapport)
#    myimap.imap_login(loginuser,loginpass)
#
#
#def imap_authenticate(imaphost,imapport,loginuser,loginpass):    # merge create instance and imap_authenticate
#    """method imap_authenticate will perform imap authenticate operation,commonly used for imap plain authentication
#       example: instance.imap_authenticate('10.49.58.239',20143,'xx1','p')
#    """    
#    myimap = IMAP_Ops(imaphost,imapport)
#    myimap.imap_authenticate(loginuser,loginpass)
#    
#    
#def imap_auth_crammd5(imaphost,imapport,loginuser,loginpass):   # merge create instance and imap_auth_crammd5
#    """method imap_auth_crammd5 will perform imap cram-md5 authentication
#       example: instance.imap_auth_crammd5('10.49.58.239',20143,'xx1','p')
#    """    
#    myimap = IMAP_Ops(imaphost,imapport)
#    myimap.imap_auth_crammd5(loginuser,loginpass)
#       
    
        