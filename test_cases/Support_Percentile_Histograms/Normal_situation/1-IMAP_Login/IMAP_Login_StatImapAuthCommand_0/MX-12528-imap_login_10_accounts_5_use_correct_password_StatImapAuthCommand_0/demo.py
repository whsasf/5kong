#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
#import HTMLTestRunner

class MyTest(unittest.TestCase):
    """dddd"""
    def setUp(self):
        print('beginnnnnnnnnnnnnnnnnnnnnnning')
        import setup.py
    def tearDown(self):
        print("enddddddddddddddddddddddddding")
        import 
    def test1(self):
        print('testttttttttttttttttttttttting')
        a=5
        self.assertEqual(a,5)
    
    
if __name__=='__main__':
    unittest.main()
    #suite=unittest.TestSuite()
    #suite.addTest(unittest.makeSuite(MyTest))
    
    #fw=open('test.html','wb')
    #runner=HTMLTestRunner.HTMLTestRunner(stream=fw,title='MX_QATesting',description='miaoshu')
    
