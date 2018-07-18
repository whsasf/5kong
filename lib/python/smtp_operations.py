# -*- coding: utf-8 -*- 
# this module contains the IMAP operation related classes and functions

# import need moduels

from smtplib import SMTP
import global_variables
import basic_class
import remote_operations
import time


def send_notify(subject,body,attachment_name,attachment_data):
    """by default this function is used to send teststatistic info of test casesat the end of test"""
    
    basic_class.mylogger_recordnf.title('\n[[Section3: Delivering notify messages to all involved QA testers ...]]')
    basic_class.mylogger_record.info('step1:get needed variables:')
    notify_user,default_domain,mx_account,root_account,root_passwd,mx1_host1_ip,mx1_mta_host1_ip,mx1_mta_host1_SMTPPort,rcpts=global_variables.get_values('notify_user','default_domain','mx_account','root_account','root_passwd','mx1_host1_ip','mx1_mta_host1_ip','mx1_mta_host1_SMTPPort','rcpts')
    basic_class.mylogger_record.debug('sender='+str(notify_user+'@'+default_domain))
    
    root_passwd,basic_class.mylogger_record.info('step2:enable smtprelay:')
    remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'imconfcontrol -install -key \"/*/mta/relaySourcePolicy=allowAll\";imconfcontrol -install -key \"/inbound-standardmta-direct/mta/relaySourcePolicy=allowAll\"\''.format(mx_account),root_account,root_passwd,0)
        
    root_passwd,basic_class.mylogger_record.info('step3:create send user:'+str(notify_user+'@'+default_domain))
    remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'account-create {1}@{2}   test default\''.format(mx_account,notify_user,default_domain),root_account,root_passwd,1,'Mailbox Created Successfully',1)
    
    root_passwd,basic_class.mylogger_record.info('step4:deliver statistic messages to all related persions ...')   
    root_passwd,basic_class.mylogger_record.debug('rcpts are:'+str(rcpts.split(' ')))
    fast_send_mail(mx1_mta_host1_ip,mx1_mta_host1_SMTPPort,notify_user+'@'+default_domain,rcpts.split(' '),subject=subject,body=body,attachment_name=attachment_name,attachment_data=attachment_data)
    time.sleep(5)
    
    root_passwd,basic_class.mylogger_record.info('step5:disable smtprelay:')
    remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'imconfcontrol -install -key \"/*/mta/relaySourcePolicy=denyAll\";imconfcontrol -install -key \"/inbound-standardmta-direct/mta/relaySourcePolicy=denyAll\"\''.format(mx_account),root_account,root_passwd,0)

    root_passwd,basic_class.mylogger_record.info('step6:delete send user:test@openwave.com')
    remote_operations.remote_operation(mx1_host1_ip,'su - {0} -c \'account-delete {1}@{2}\''.format(mx_account,notify_user,default_domain),root_account,root_passwd,1,'Mailbox Deleted Successfully',1)

             
def fast_send_mail (mtahost,mtaport,fromuser,tousers,\
    marker = 'AUNIQUEMARKER',\
    mimeinfo = 'This is a multi-part message in MIME format.',\
    subject = 'Sending Attachement',\
    body = 'This is a test email to send an attachement,haha,are you OK? we love world !!!!!!ucucucucucucccc\n\nTHERE was no possibility of taking a walk that day. We had been wandering, indeed,\nin the leafless shrubbery an hour in the morning; but since dinner (Mrs. Reed, when\nthere was no company, dined early) the cold winter wind had brought with it clouds \nso sombre, and a rain so penetrating, that further outdoor exercise was now out of \nthe question. I was glad of it: I never liked long walks, especially on chilly afternoons:\ndreadful to me was the coming home in the raw twilight, with nipped fingers and toes, \nand a heart saddened by the chidings of Bessie, the nurse, and humbled by the consciousness\nof my physical inferiority to Eliza, John, and Georgiana Reed. The said Eliza, John, and \nGeorgiana were now clustered round their mama in the drawing-room: she lay reclined on \na sofa by the fireside, and with her darlings about her (for the time neither quarrelling \nnor crying) looked perfectly happy. Me, she had dispensed from joining the group; saying, \nShe regretted to be under the necessity of keeping me at a distance; but that until she heard \nfrom Bessie, and could discover by her own observation, that I was endeavouring in good earnest \nto acquire a more sociable and childlike disposition, a more attractive and sprightly manner- \nsomething lighter, franker, more natural, as it were- she really must exclude me from privileges \nintended only for contented, happy, little children. What does Bessie say I have done? I asked.\nJane, I dont like cavillers or questioners; besides, there is something truly forbidding ina \nchild taking up her elders in that manner. Be seated somewhere; and until you can speak pleasantly, \nremain silent.',\
    attachment_name = 'attach.txt',\
    attachment_data = 'world peace.are u OK?hahahahahaha\n\nA small breakfast-room adjoined the drawing-room, I slipped in there. It contained a bookcase: I soon possessed myself of a volume, taking care that it should be one stored with pictures. I mounted into the window-seat: gathering up my feet, I sat cross-legged, like a Turk; and, having drawn the red moreen curtain nearly close, I was shrined in double retirement. Folds of scarlet drapery shut in my view to the right hand; to the left were the clear panes of glass, protecting, but not separating me from the drear November day. At intervals, while turning over the leaves of my book, I studied the aspect of that winter afternoon. Afar, it offered a pale blank of mist and cloud; near a scene of wet lawn and storm-beat shrub, with ceaseless rain sweeping away wildly before a long and lamentable blast. I returned to my book- Bewicks History of British Birds: the letterpress thereof I cared little for, generally speaking; and yet there were certain introductory pages that, child as I was, I could not pass quite as a blank. They were those which treat of the haunts of sea-fowl; of the solitary rocks and promontories by them only inhabited; of the coast of Norway, studded with isles from its southern extremity, the Lindeness, or Naze, to the North Cape- Where the Northern Ocean, in vast whirls, Boils round the naked, melancholy isles   Of farthest Thule; and the Atlantic surge Pours in among the stormy Hebrides.Nor could I pass unnoticed the suggestion of the bleak shores of Lapland, Siberia, Spitzbergen, Nova Zembla, Iceland, Greenland, with the vast sweep of the Arctic Zone, and those forlorn regions of dreary space,- that reservoir of frost and snow, where firm fields of ice, the accumulation of centuries of winters, glazed in Alpine heights above heights, surround the pole and concentre the multiplied rigours of extreme cold. Of these death-white realms I formed an idea of my own: shadowy, like all the half-comprehended notions that float aim through childrens brains, but strangely impressive. The words in these introductory pages connected themselves with the succeeding vignettes, and gave significance to the rock standing up alone in a sea of billow and spray; to the broken boat stranded on a desolate coast; to the cold and ghastly moon glancing through bars of cloud at a wreck just sinking. \nI cannot tell what sentiment haunted the quite solitary churchyard, with its inscribed headstone; its gate, its two trees, its low horizon, girdled by a broken wall, and its newly-risen crescent, attesting the hour of eventide. The two ships becalmed on a torpid sea, I believed to be marine phantoms. The fiend pinning down the thiefs pack behind him, I passed over quickly: it was an object of terror. So was the black horned thing seated aloof on a rock, surveying a distant crowd surrounding a gallows. Each picture told a story; mysterious often to my undeveloped understanding and imperfect feelings, yet ever profoundly interesting: as interesting as the tales Bessie sometimes narrated on winter evenings, when she chanced to be in good humour; and when, having brought her ironing-table to the nursery hearth, she allowed us to sit about it, and while she got up Mrs. Reeds lace frills, and crimped her nightcap borders, fed our eager attention with passages of love and adventure taken from old fairy tales and other ballads; or (as at a later period I discovered) from the pages of Pamela, and Henry, Earl of Moreland. With Bewick on my knee, I was then happy: happy at least in my way. I feared nothing but interruption, and that came too soon. The breakfast-room door opened.\nBoh! Madam Mope! cried the voice of John Reed; then he paused: he found the room apparently empty.\nWhere the dickens is she! he continued. Lizzy! Georgy! (calling to his sisters) Joan is not here: tell mama she is run out into the rain- bad animal!\nIt is well I drew the curtain, thought I; and I wished fervently he might not discover my hiding-place: nor would John Reed have found it out himself;                                    he was not\nquick either of vision or conception; btEliza just put her head in at the door, and said at once-\nShe is in the window-seat, to be sure, Jack.\nAnd I came out immediately, for I trembled at the idea of being dragged forth by the said Jack.\nWhat do you want? I asked, with awkward diffidence.\nSay, "What do you want, Master Reed?" was the answer. I want you to come here; and seating himself in an armchair, he intimated by a gesture that I was to approach and stand before him.\nJohn Reed was a schoolboy of fourteen years old; four years older than I, for I was but ten: large and stout for his age, with a dingy and unwholesome skin; thick lineaments in a spacious visage, heavy limbs and large extremities. He gorged himself habitually at table, which made him bilious, and gave him a dim and bleared eye and flabby cheeks. He ought now to have been at school; but his mama had taken him home for a month or two, on account of his delicate health. Mr. Miles, the master, affirmed that he would do very well if he had fewer cakes and sweetmeats sent him from home; but the mothers heart turned from an opinion so harsh, and inclined rather to the more refined idea that Johns sallowness was owing to over-application and, perhaps, to pining after home.\nJohn had not much affection for his mother and sisters, and an antipathy to me. He bullied and punished me; not two or three times in the week, nor once or twice in the day, but continually: every nerve I had feared him, and every morsel of flesh in my bones shrank when he came near. There were moments when I was bewildered by the terror he inspired, because I had no appeal whatever against either his menaces or his inflictions; the servants did not like to offend their young master by taking my part against him, and Mrs. Reed was blind and deaf on the subject: she never saw him strike or heard him abuse me, though he did both now and then in her very presence, more frequently, however, behind her back.\nHabitually obedient to John, I came up to his chair: he spent some three minutes in thrusting out his tongue at me as far as he could without damaging the roots: I knew he would soon strike, and while dreading the blow, I mused on the disgusting and ugly appearance of him who would presently deal it. I wonder if he read that notion in my face; for, all at once, without speaking, he struck suddenly and strongly. I tottered, and on regaining my equilibrium retired back a step or two from his chair.\nThat is for your impudence in answering mama awhile since, said he, and for your sneaking way of getting behind curtains, and for the look you had in your eyes two minutes since, you rat!\nAccustomed to John Reeds abuse, I never had an idea of replying to it; my care was how to endure the blow which would certainly follow the insult.\nWhat were you doing behind the curtain? he asked.\nI was reading.\nShow the book.\nI returned to the window and fetched it thence.\nYou have no business to take our books; you are a dependant, mama says; you have no money; your father left you none; you ought to beg, and not to live here with gentlemens children like us, and eat the same meals we do, and wear clothes at our mamas expense. Now, Ill teach you to rummage my bookshelves: for they are mine; all the house belongs to me, or will do in a few years. Go and stand by the door, out of the way of the mirror and the windows.I did so, not at first aware what was his intention; but when I saw him lift and poise the book and stand in act to hurl it, I instinctively started aside with a cry of alarm: not soon enough, however; the volume was flung, it hit me, and I fell, striking my head against the door and cutting it. The cut bled, the pain was sharp: my terror had passed its climax; other feelings succeeded.\nWicked and cruel boy! I said. You are like a murderer- you are like a slave-driver- you are like the Roman emperors!\nI had read Goldsmiths History of Rome, and had formed my opinion of Nero, Caligula, etc. Also I had drawn parallels in silence, which I never thought thus                        to have declared aloud.\nWhat! what! \ne cried. Did she say that to me? Did you hear her, Eliza and Georgiana? Wont I tell mama? but first- He\nran headlong at me: I felt him grasp my hair and my shoulder:\nhe had closed with a desperate thing. I really saw in him a tyrant, a murderer. I felt a drop or two of blood from my head trickle down my neck, and was sensible of somewhat pungnt \nsuffering: these sensations for the time predominated over fear, and I received him in frantic sort. I dont very well know what I did with my hands, but he called me Rat! Rat! and\nbellowed out aloud. Aid was near him: Eliza and Georgiana had run for Mrs. Reed, who was gone upstairs: she now came upon the scene, followed by Bessie and her maid Abbot. We wre \nparted: I heard the words-\nDear! dear! What a fury to fly at Master John!\nDid ever anybody see such a picture of passion!\nThen Mrs. Reed subjoined-\nTake her away to the red-room, and lock her in there. Four hands were immediately laid upon me, and I was borne upstairs.',\
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
    attdata = str(base64.b64encode(attachment_data.encode('utf-8')),'utf-8')
     #with open(filename, 'rw') as file_object:
     #    file_object.write(attdata)
    
    # Define the main headers.
    part1 = """From: %s
    To: %s
    Subject: %s
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary=%s
    %s
    --%s
    """.replace('\n    ','\n') %(sender,','.join(recievers),subject,marker,mimeinfo,marker)
    
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
    """.replace('\n    ','\n') %(attachment_name, attachment_name, attdata, marker)
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