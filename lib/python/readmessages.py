def imap_fetch(imaphost,imapport,mailboxname,loginuser,loginpass):
	
    from imaplib import IMAP4
    import time
    
    conn = IMAP4(host='10.49.58.239', port=20143)
    conn.login(loginuser,loginpass)
    conn.select(mailbox='INBOX', readonly=False)
    #message=b"FROM: xx2\r\n\
    #to:xx1\r\n\
    #\r\n\
    #helo world\r\n"
    #epochtime = int(time.time())
    #conn.append('INBOX','unseen',epochtime,message )
    
    outcome, data1=conn.fetch("1:*",'rfc822')
    
    i = 1
    #print (data1)
    #print (data)
    #print ("++++++++++++++++++++++++++++")
    for x in data1:
        if b'FLAGS' in x or  x == b')':
            continue
        else:
            print ('\033[1;32mMessage' + str(i) +": \033[0m")
            #print (x[0].decode('utf-8'))
            #print (x[1])
            print (x[1].decode('utf-8'))
            #print ("\n")
        i=i+1
    
    outcome, data2=conn.fetch("1:*",'firstline')
    #print (data2)
    print ("\033[1;32mFirstline data: \033[0m")
    for x in data2:
        #print (x[0].decode('utf-8'))
        print (x.decode('utf-8'))
        #print ("\n")
        
    conn.logout()
