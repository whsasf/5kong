#!/bin/bash

for file in $(find .|grep '.py$')
do
#echo $file

sed -i '/remote_operations.remote_operation/s/root_account,root_passwd,//g'  $file
sed -i '/remote_operations.remote_operation/s/,0)/,root_account,root_passwd,0)/g'  $file
sed -i '/remote_operations.remote_operation/s/,1,/,root_account,root_passwd,1,/g'  $file

done