#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import basic_class
import global_variables
import time
import shutil
import subprocess

# run

basic_class.mylogger_record.info('Begin running Imsanity testing ...')
imsanity_test = global_variables.get_value('imsanity_test')
outcode = subprocess.run(['{}'.format(imsanity_test)])
basic_class.mylogger_record.info('the outcode of running imsanity is:'+str(outcode))

# copy summary.log
summarypath = global_variables.get_value('summarypath')
shutil.copy2('summary.log', '{}/imsanity-summary.log'.format(summarypath))
