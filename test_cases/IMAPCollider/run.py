#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import basic_class
import global_variables
import time
import shutil
import subprocess

# run

basic_class.mylogger_record.info('Begin running IMAPCollider testing ...')
imap_collider = global_variables.get_value('imap_collider')
outcode = subprocess.run(['{}'.format(imap_collider)])
basic_class.mylogger_record.info('the outcode of running IAMP collider is:'+str(outcode))

# copy summary.log
summarypath = global_variables.get_value('summarypath')
shutil.copy2('IC_Summary.log', '{}/IC_Summary.log'.format(summarypath))
