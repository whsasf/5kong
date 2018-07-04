#!/bin/bash
#Load basic function and utilities functions and MX-function shell
.  System_depend_scripts/base_func.sh
.  System_depend_scripts/utility_func.sh
.  System_depend_scripts/MX-Functions.sh  
.  System_depend_scripts/definition.sh

#loading all kinds of functions finished
#define test scripts names
roothome=$(pwd)
Definition

# tidy function to do the cleanup job if forced stopped
trap tidy SIGHUP SIGINT SIGTERM
function tidy (){
	echo -e "\nDoing some tidy work before full exiting ...\n"
	echo -e "\nDoing some tidy work before full exiting ...\n" >>$debuglog
	if [ -f $Cleanup ]
	then
		. $(pwd)/$Cleanup
		rm -rf *.tmp
	fi
	cd $roothome
	if [ -f $Cleanup ]
	then
		. $(pwd)/$Cleanup
		rm -rf *.tmp
	fi	
	summary_imsanity
}

#clear current data
> $debuglog
> $summarylog
> $imaplog
> $poplog
> $mtalog
> $Alltestcasestimetxt

#run welcome inof and detect path
welcome

echo
#clear FEP logs
clearfeplog
echo
#clear cores
clearcore

echo
starttime=$(date)
#get MX component versions
imsanity_version

#gather MX info
GatherMXinfo

#initial static
TotalTestCases=0
Pass=0
Fail=0
set_color "0"
echo >> $summarylog
echo "======================================================= MX testcses =====================================================" >> $summarylog

#traverse all folders,this is core parts of this shell script
function run (){
  	#Run setup and test sripts if exist
  	cupath=$(pwd)
    if [ "$cupath" != "$roothome" ];then  	  
  	  printflag=$(find . -type d  |grep -v ^.$)
  	  if [  -n "$printflag" ];then
  	  	printtestsuit 1
  	  else
  	    printtestsuit 
  	  fi  	  
  	fi
  	
		if [ -f $Setup ];then
			echo -e "\033[35m===== Setting Up ...\033[0m"
			echo -e "\033[35m===== Setting Up ...\033[0m" >>debug.log
			. $(pwd)/$Setup
		fi
		if [ -f $Test ];then
			echo -e "\033[35m===== Testing ...\033[0m"
			echo -e "\033[35m===== Testing ...\033[0m" >>debug.log
			. $(pwd)/$Test
		fi
		
		for dir in $(find . -maxdepth 1 -type d |grep -v ^.$|grep -v git|sort)
		do
			#go to prevous level if already reach the bottom of this folder line.
			if [ ! -n "$dir" ];then
				if [ -f $Cleanup ]
				then
					echo -e "\033[35m===== Cleaning Up ...\033[0m"
    		  echo -e "\033[35m===== Cleaning Up ...\033[0m" >>debug.log
					. $(pwd)/$Cleanup
					cat debug.log   >> $debuglog
					cat summary.log >> $summarylog 
					rm -rf *.tmp
				fi
				cd ..
			else 
				#go to each sub folder
				cd $dir
				run
				cd ..
			fi
		done
		if [ -f $Cleanup ]
		then
			echo -e "\033[35m===== Cleaning Up ...\033[0m"
			echo -e "\033[35m===== Cleaning Up ...\033[0m" >>debug.log
			. $(pwd)/$Cleanup
			cat debug.log   >> $debuglog
			cat summary.log >> $summarylog 
			rm -rf *.tmp
		fi
}

#Run test cases
if [ ! -n "$1" ]
then
  #run all test cases
  echo "Running all testcases,priority1_testcases by default ..."
  echo "Running all testcases,priority1_testcases by default ..." >>$debuglog
  cd priority1_testcases/   # eun priority1_testcases by default
	run
else
  #run special testcase
  currentpath=$(pwd)
  if [ -f $Setup ];then
  	echo -e "\033[35m===== Setting Up ...\033[0m"
		echo -e "\033[35m===== Setting Up ...\033[0m" >>debug.log
		. $(pwd)/$Setup
	fi
  for (( ii=1;ii<=$#;ii++ ))
  do
    echo -e "\n\n"
  	echo -e "\n\n" >> $debuglog
  	cd "${!ii}"
  	if [ "$?" == "0" ];then
  	 
  		run
  	else
  		echo -e "\033[31m!!!!!!!!!! Folder "${!ii}" does not exists,please double confirm!!!!!!!!!!\n\033[0m"
  		echo -e "\033[31m!!!!!!!!!! Folder "${!ii}" does not exists,please double confirm!!!!!!!!!!\n\033[0m" >>$debuglog
  		continue
  	fi
  	cd $currentpath 
  done
  cd $currentpath
  if [ -f $Cleanup ]
	then
		echo -e "\033[35m===== Cleaning Up ...\033[0m"
		echo -e "\033[35m===== Cleaning Up ...\033[0m" >>debug.log
		. $(pwd)/$Cleanup
		cat debug.log   >> $debuglog
		cat summary.log >> $summarylog 
		rm -rf *.tmp
  fi
fi

#Summary
summary_imsanity 