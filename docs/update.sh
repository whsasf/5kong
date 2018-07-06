#!/bin/bash

for file in $(find .|grep '.py$')
do
#echo $file
sed -i 's/mx2_imap1_host_ip/mx2_imapserv_host1_ip/g'  $file
sed -i 's/mx2_imap1_port/mx2_imapserv_host1_imap4Port/g'  $file
sed -i 's/mx2_imap1_sslport/mx2_imapserv_host1_sslImap4Port/g'  $file
sed -i 's/mx2_imap1_host/mx2_imapserv_host1/g'  $file

sed -i 's/mx2_pop1_host_ip/mx2_popserv_host1_ip/g'  $file
sed -i 's/mx2_pop1_port/mx2_popserv_host1_pop3Port/g'  $file
sed -i 's/mx2_pop1_sslport/mx2_popserv_host1_sslPop3Port/g'  $file
sed -i 's/mx2_pop1_host/mx2_popserv_host1/g'  $file

sed -i 's/mx2_mta1_host_ip/mx2_mta_host1_ip/g'  $file
sed -i 's/mx2_mta1_port/mx2_mta_host1_SMTPPort/g'  $file
sed -i 's/mx2_mta1_sslport/mx2_mta_host1_sslSMTPPort/g'  $file
sed -i 's/mx2_mta1_host/mx2_mta_host1/g'  $file

sed -i 's/mx2_mss1_host_ip/mx2_mss_host1_ip/g'  $file
sed -i 's/mx2_mss1_host/mx2_mss_host1/g'  $file

sed -i 's/mx2_mss2_host_ip/mx2_mss_host2_ip/g'  $file
sed -i 's/mx2_mss2_host/mx2_mss_host2/g'  $file

sed -i 's/mx2_mxos1_host_ip/mx2_mxos_host1_ip/g'  $file
sed -i 's/mx2_mxos1_port/mx2_mxos_host1_eureka_port/g'  $file
sed -i 's/mx2_mxos1_host/mx2_mxos_host1/g'  $file

sed -i 's/mx2_mxos2_host_ip/mx2_mxos_host2_ip/g'  $file
sed -i 's/mx2_mxos2_port/mx2_mxos_host2_eureka_port/g'  $file
sed -i 's/mx2_mxos2_host/mx2_mxos_host2/g'  $file
sed -i 's/mx2_blobstore_host_ip/mx2_cassblob_ip/g'  $file
sed -i 's/mx2_blobstore_port/mx2_search_cassandraBlobPort/g'  $file

done