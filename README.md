#**5kong test tool for MX backend QA**

**brief introduction:**

5kong test tool is a python3 composed test tool for MX QA team to create new testcases and drive legendary testcases like Imsanity, Imap_Collider,bohem and TTI. Except the basic functions existed in above test framework, new feature can be easily introducted thanks to the conveniencd modules introducted by Python.

-----

###1.[Python3 preparation](https://confluence.synchronoss.net:8443/display/MSGEN/Steps+to+install+Python+3.X+in+CentOS)

###2.Get all dependent external libs via: **pip3 install -r requirements.txt**

###3.5kong test tool Usage:
This test framework can be run on any servers with python3 prepared, locally or remotely to the test machine ,since whole freamework and all testcases are based on SSH. 

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

	[testcases] here can be:
	- empty: will use default testcase location: test_case
	- specific location(s): any preferred location(s) that containing the testcases,can be multiple
	- testcase.list:  it contains the testcases that need run,per testcases per line	 
	e.g.
	./5kong_run.py  -v -n
	./5kong_run.py  test1  /opt/test2     /var/test3   -v -n
	./5kong_run.py    testcase.list   -v -n

###4.Some functions this test framework can provide:
	1. send notifications after running testcases (-n)
	2. auto detect and construct MX topology bases on seed hosts
	3. can initiate lagency test framework to run and gather summary.would have more control to legency testcases in the future
	4. support multiple testcases finding
	5. 
	
###5. TODO
	1. write more functions,especially SSH bases command,like imdbcontrol xxxx, and normal shell commands
	2. restruct and optimize framework,functions,logic
	3. add more exception handling
	4. add wait and retry handling
	5 introduce unittest framework, mainly affect testcase compose
	6 extend framework to run any knid of scripts ,like sh,pl ,as conveince as py
	7. 
	