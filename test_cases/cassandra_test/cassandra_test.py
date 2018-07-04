#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

import cassandra
from cassandra.cluster import Cluster
from cassandra.query import dict_factory
from cassandra.policies import RoundRobinPolicy
from cassandra import ConsistencyLevel 
from Crypto.Cipher import AES

cluster = Cluster(['10.49.58.240'],port=9043,connect_timeout=60)
session = cluster.connect('KeyspaceBlobStore')
#session.row_factory = dict_factory
session.default_consistency_level  = ConsistencyLevel.LOCAL_QUORUM

for i in range(0,20):
    target = 'select * from "CF_Message_{}" where key=0x{};'.format(i,'4ba1e114-7d01-11e8-b327-409c714fedb7'.replace('-',''))
    
    print(target)
    rows = session.execute(target,timeout=6000)
    #print(rows[:])
    if rows:
        #print('i===='+str(i))
        #print(list(rows))
        #[print(row[2]) for row in rows]
        #print('------------------------------------------------------------------------------')  
        for row in rows:
            #print(row[0])
            print(row[1])
            if row[1] == 101:
                print(row[2])
            #print(row[2])
        #    print(c)
            #tmp = row[2].decode('utf-8','ignore')
            #print(r'{}'.format(tmp))
            #tmp = tmp[tmp.rindex('\x00'):]
            #print(tmp)
    #        print(row)                              
cluster.shutdown()
