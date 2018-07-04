

def send_mail (mtahost,mtaport,fromuser,tousers,\
    marker = 'AUNIQUEMARKER',\
    mimeinfo = 'This is a multi-part message in MIME format.',\
    body = 'this is the outcome of testcases:\nhahah\nhahha\nhaha',\
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
    Subject: Testcase outcome
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
       print ("\033[1;32m  Email sent successfully\033[0m")
    except smtplib.SMTPException:
       print ("\033[1;31m  Email sent unsuccessfully\033[0m")
    smtpObj.quit()