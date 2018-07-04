#**5kong test tool for MX backend QA**

**brief introduction:**

5kong test tool is a python3 composed test tool for MX QA team to create new testcases and drive legendary testcases like Imsanity, Imap_Collider,bohem and TTI. Except the basic functions existed in above test framework, new feature can be easily introducted thanks to the conveniencd modules introducted by Python.

-----

###1.[Python3 preparation](https://confluence.synchronoss.net:8443/display/MSGEN/Steps+to+install+Python+3.X+in+CentOS)

###2.Get all dependent external libs via: **pip3 install -r requirements.txt**

###3.5kong test tool Usage:

	./5kong_run.py [testcases] [-v|-n]            --recommand to initiate this tool from it's main path
	or
	python3 5kong_run.py  [testcases] [-v|-n]
	or
	xx1/xx2/5kong/5kong_run.py  [testcases] [-v|-n]   
	or 
	python3 xx1/xx2/5kong/5kong_run.py  [testcases] [-v|-n]   
	
	testcase: the path that testcase locates,will use defult test_case path if left blank.
	          It can allow a testcase.list file that contains the path of testcases or
	          specific testcase locations.
	-v:       enable verbose mode
	-n:       enable notification messages to be sent after testting



###4.df