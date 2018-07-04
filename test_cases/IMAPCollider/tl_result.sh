#!/bin/sh

#Usage(){
#   echo
#   echo "Please run this script under IMAPCollider/"
#   echo
#   exit 255
#}



TL_ID="tlid.txt"
sum_log="Logs/IC_Summary.log"
TL_log="tl_result_im.xml"
if [ ! -f $TL_ID ]; then
    echo "$TL_ID:No such file"
    exit 1
fi

if [ ! -f $sum_log ];then 
   echo "$sum_log:No such file"
   exit 1

fi

echo '<?xml version="1.0" encoding="UTF-8"?>' > $TL_log
echo '<results>' >> $TL_log


while read line
do
    tc=`echo $line | cut -d " " -f1`
    n=`echo $tc| grep TC_ |wc -l`
    if [ $n -eq 1 ];then 
#re=`echo $line | awk '{print $3}'`
        id=`cat ${TL_ID} |grep ${tc} |cut -d " " -f2`
        echo "<testcase id=\"$id\"><result>p</result></testcase>" >>$TL_log
    fi
done < $sum_log

echo '</results>' >>$TL_log
echo "Done!"
echo "Pls check ${TL_log}"
