#!/usr/bin/python
import os
import re
import datetime
import remote_operations import remote_operation
import socket

Host='10.49.58.239'
User='imail'
now = datetime.datetime.now()
def get_services(Host, User):
  debug=1
  Host_list,Port_list,Addr_list=[],[],[]
  allHost_common_user_home=''
  ssh_allHost=paramiko.SSHClient()
  ssh_allHost.load_system_host_keys()
  ssh_allHost.connect(Host,22,User,User)
  tmp_cmd='cat /etc/passwd|grep '+User+'|cut -d\':\' -f6'
  stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
  if (len(stderr.read())==0):
    allHost_common_user_home=stdout.read().strip()
  else:
    print 'Error'
  tmp_cmd='source '+allHost_common_user_home+'/.profile; imconfcontrol -ports'
  stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
  if (len(stderr.read())==0):
    tmp_list=stdout.readlines()
    for hostports in tmp_list:
      hostports=re.sub('\n','',hostports)
      hostports=re.sub('^[ ]*','',hostports)
      hostports=re.sub('[ ]+',' ',hostports)
      tmp_a=hostports.split(' ')
#      if not tmp_a[0].isdigit():
#         continue
      if tmp_a[0].isdigit():
         tmp_cmd='source '+allHost_common_user_home+'/.profile; imconfget -server '+ tmp_a[2]
         stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
         s_list=stdout.readlines()
         for serverhosts in s_list:
             serverhosts=re.sub('\n','',serverhosts)
             server_tmp=serverhosts.split(' ')
         for x in range(len(server_tmp)-1):
             Host_list.append(tmp_a[2]+'_host'+str(x+1)+' = '+server_tmp[x] )
             Port_list.append(tmp_a[2]+'_host'+str(x+1)+'_'+tmp_a[3]+' = '+tmp_a[0])
      #else:
      #   Host_list.append(tmp_a[2]+'_host1: '+tmp_a[1])
      #   Port_list.append( tmp_a[2]+'_'+tmp_a[3]+': '+tmp_a[0] )

  else:
    print 'Error'

# get hosts and hosts' ip addrs
  tmp_cmd='source '+allHost_common_user_home+'/.profile;imconfget  -hosts | grep -v cluster'
  stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
  h_list=stdout.readlines()
  print h_list
  for x in range(len(h_list)-1):
    addrlist=re.sub('\n','',h_list[x])
    if len(addrlist):
        Addr_list.append("Host"+str(x+1)+' = ' + addrlist)
        tmp_cmd="grep "+addrlist+" /etc/hosts|awk \'{print $1}\' | head -1"
        stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
        tmpip=stdout.readlines()
        Addr_list.append("Host"+str(x+1)+"_IP = "+''.join(tmpip)) 


# get cassandra info
  Cass_list=[]
  tmp_cmd='grep hostInfo '+allHost_common_user_home+'/config/config.db | cut -d \':\' -f 3'
  stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
  b_n=stdout.readlines()
  blobtier=re.sub('\n','',b_n[0])
  tmp_cmd="grep "+blobtier+" /etc/hosts|awk \'{print $1}\' | head -1"
  stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
  tmp_ip=stdout.readlines()
  blob_ip=re.sub('\n','',tmp_ip[0])
  Cass_list.append("cassblobhosts =" + blobtier)
  Cass_list.append("cassblobip = " + blob_ip)

  tmp_cmd='grep cassandraMDCluster '+allHost_common_user_home+'/config/config.db | cut -d \'[\' -f 2| cut -d \']\' -f1 '
  stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
  m_n=stdout.readlines()
  metadata=re.sub('\n','',m_n[0])
  tmp_cmd="grep "+metadata+" /etc/hosts|awk \'{print $1}\' | head -1"
  stdin,stdout,stderr=ssh_allHost.exec_command(tmp_cmd)
  tmp_ip=stdout.readlines()
  meta_ip=re.sub('\n','',tmp_ip[0])
  Cass_list.append("cassmetahosts = "+metadata)
  Cass_list.append("cassmetaip = " +meta_ip)

 

  if not os.path.exists("reports"):
     os.makedirs("reports")
  var_file = open("reports/user_vars"+str(now.date()), "w")
  tmp_list=list(set(Host_list+Port_list+Addr_list+Cass_list))
  tmp_list=sorted(tmp_list)
  for h in tmp_list:
    var_file.write(h+"\n")
#  for s in set(Port_list):
#    var_file.write(s+"\n")
  var_file.close()

#  print set(Host_list)
#  print set(Port_list)


get_services(Host, User)
