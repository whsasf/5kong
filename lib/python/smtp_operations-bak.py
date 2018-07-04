# -*- coding: utf-8 -*- 
# this module contains the IMAP operation related classes and functions

# import need moduels

from smtplib import SMTP
import global_variables
import basic_class


def fast_send_mail (mtahost,mtaport,fromuser,tousers,\
    marker = 'AUNIQUEMARKER',\
    mimeinfo = 'This is a multi-part message in MIME format.',\
    body = '-xxxxxxxxxxThis is a test email to send an attachement,haha,are you OK? we love world !!!!!!ucucucucucucucucucucucucucuc',\
    ):
    """ this function is used to send email"""
    #import basic libs
    import smtplib
    import base64

    #define variables
    smtphost = mtahost
    smtpport = mtaport
    sender = fromuser
    recievers = tousers
    #body = str(cc)+ body
    filename = 'attach.txt'  #create a attachment file
    attdata = str(base64.b64encode('world peace.are u OK?hahahahahaha'.encode('utf-8')),'utf-8')
     #with open(filename, 'rw') as file_object:
     #    file_object.write(attdata)
    
    # Define the main headers.
    part1 = """From: %s
    To: %s
    Subject: Sending Attachement
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary=%s
    %s
    --%s
    """.replace('\n    ','\n') %(sender,','.join(recievers),marker,mimeinfo,marker)
    
    # Define the message action
    part2 = """Content-Type: text/plain
    Content-Transfer-Encoding:8bit

    %s
    --%s
    """.replace('\n    ','\n') %(body,marker)
    
    # Define the attachment section
    part3 = """Content-Type: text/plain; name=\"%s\"
    Content-Transfer-Encoding:base64
    Content-Disposition: attachment; filename=\"%s\"

    %s
    --%s--
    """.replace('\n    ','\n') %(filename, filename, attdata, marker)
    message = part1 + part2 + part3

    try:
       smtpObj = smtplib.SMTP(smtphost,smtpport)
       #print ("recievers="+str(recievers))
       smtpObj.sendmail(sender, recievers, message)       
       print ("\033[1;32mEmail sent successfully\033[0m")
    except smtplib.SMTPException:
       print ("\033[1;31mEmail sent unsuccessfully\033[0m")
    smtpObj.quit()
    
    
    
class SMTP_OPs(SMTP):
    """define a SMTP class and related functions"""
    
    def __init__(self,smtphost, smtpport, local_hostname=None,source_address=None,rspcode='',rspdata=''):
        """initial class"""
    
        self.smtphost = smtphost
        self.smtpport = smtpport
        self.local_hostname = local_hostname
        self.source_address = source_address
        self.rspcode = rspcode
        self.rspdata = rspdata
        
        basic_class.mylogger_record.info('<init SMTP instance:smtp against >'+self.smtphost+':'+self.smtpport)
        self.smtp = SMTP(host=self.smtphost,port=self.smtpport,local_hostname=self.local_hostname,source_address=self.source_address)
    
    def smtp_connect(self,smtphost,smtpport):
        """Connect to a host on a given port and host"""
        
        self.smtphost = smtphost
        self.smtpport = smtpport
        self.rspcode,self.rspdata = self.smtp.connect(self.smtphost,self.smtpport)
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())]          
        
    def smtp_set_debuglevel(self):
        """Set the debug output level. A value of 1 or True for level results in debug messages 
        for connection and for all messages sent to and received from the server.
        A value of 2 for level results in these messages being timestamped
        smtp_debuglevel defined in etc global.vars
        """
        
        smtp_debuglevel = global_variables.get_value('smtp_debuglevel')
        basic_class.mylogger_record.debug('command:<set_debuglevel '+str(smtp_debuglevel)+'>') 
        self.smtp.set_debuglevel(int(smtp_debuglevel))
        #[basic_class.mylogger_record.debug(self.rspcode)]
        #[basic_class.mylogger_record.debug(self.rspdata.decode())]


    def smtp_helo(self):
        """Identify yourself to the SMTP server using HELO."""
        
        basic_class.mylogger_record.info('command:<helo>')
        self.rspcode,self.rspdata = self.smtp.helo()
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())]       



    def smtp_ehlo(self):
        """Identify yourself to the SMTP server using EHLO."""
        
        basic_class.mylogger_record.info('command:<ehlo>')
        self.rspcode,self.rspdata = self.smtp.ehlo()
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())]    
        

    def smtp_ehlo_or_helo_if_needed(self):  
        """This method call ehlo() and or helo() if there has been no 
        previous EHLO or HELO command this session. 
        It tries ESMTP EHLO first        
        """
        
        basic_class.mylogger_record.info('command:<ehlo_or_helo_if_needed>')
        self.rspcode,self.rspdata = self.smtp.ehlo_or_helo_if_needed()
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())]   
        
                        
    def smtp_starttls(self,keyfile=None, certfile=None, context=None):
        """Put the SMTP connection in TLS (Transport Layer Security) mode"""               
        
        self.keyfile = keyfile
        self.certfile = certfile
        self.context = context
        
        basic_class.mylogger_record.info('command:<starttls>')
        self.rspcode,self.rspdata = self.smtp.starttls(self.keyfile,self.certfile,self.context)
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())]  
        
                
        
    def smtp_login(self,user,password,initial_response_ok=True):
        """Log in on an SMTP server that requires authentication."""
        
        self.user = user
        self.password = password
        self.initial_response_ok = initial_response_ok
        basic_class.mylogger_record.info('command:<auth login '+self.user+' '+self.password+'>')
        self.rspcode,self.rspdata = self.smtp.login(self.user,self.password,initial_response_ok=self.initial_response_ok)
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())]       
        
    def smtp_auth_login(self,user,password):
        """auth login command"""
        
        self.user = user
        self.password = password
        #self.initial_response_ok = initial_response_ok

        basic_class.mylogger_record.info('command:<auth login '+self.user+' '+self.password+'>')
        self.rspcode,self.rspdata = self.smtp.auth_login(self.user,self.password)
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())]   
        
        
                
    def smtp_auth(self,user,password,mechanism,authobject,initial_response_ok=True):
        """Log in on an SMTP server that requires authentication."""
        
        self.user = user
        self.password = password
        self.mechanism = mechanism
        self.authobject = authobject
        self.initial_response_ok = initial_response_ok
        
        basic_class.mylogger_record.info('command:<auth login '+self.user+' '+self.password+'>')
        self.rspcode,self.rspdata = self.smtp.login(self.user,self.password,initial_response_ok=self.initial_response_ok)
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())] 



    def smtp_sendmail(self,from_addr, to_addrs, msg, mail_options=[], rcpt_options=[]):
        """Send mail"""             
        
        self.from_addr = from_addr
        self.to_addrs = to_addrs
        self.msg = msg
        self.mail_options = mail_options
        self.rcpt_options = rcpt_options
        
        basic_class.mylogger_record.info('command:sendmail from:'+self.from_addr+' to:'+self.to_addrs)
        self.rspcode,self.rspdata = self.smtp.sendmail(self.from_addr,self.to_addrs,self.msg,self.mail_options,self.rcpt_options)
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())]        

            
    def smtp_quit(self):
        """Terminate the SMTP session and close the connection"""
        
        basic_class.mylogger_record.info('command:<quit>')
        self.rspcode,self.rspdata = self.smtp.quit()
        [basic_class.mylogger_record.debug(self.rspcode)]
        [basic_class.mylogger_record.debug(self.rspdata.decode())] 
        #[basic_class.mylogger_record.debug(self.resp.decode())]