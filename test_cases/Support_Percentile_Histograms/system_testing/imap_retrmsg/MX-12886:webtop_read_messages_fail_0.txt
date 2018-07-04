1 set key: /*/common/perfStatThresholds: [StatMSSRetrMsg 0]

2 login ,fetch 2 messages, logout ,


3 damage the mesge, fetch message failed,but can still see counts:

20180626 041036126-0400 mx1 imapserv 2935;StatMSSRetrMsg(77/571) 0/sec 26 ms [0] 8/0/8 209/1/40
20180626 041106126-0400 mx1 imapserv 2935;StatMSSRetrMsg(77/571) 0/sec 0 ms [0] 0/0/0 0/0/0
20180626 041136129-0400 mx1 imapserv 2935;StatMSSRetrMsg(77/571) 0/sec 0 ms [0] 0/0/0 0/0/0
20180626 041206130-0400 mx1 imapserv 2935;StatMSSRetrMsg(77/571) 0/sec 0 ms [0] 0/0/0 0/0/0
20180626 041236130-0400 mx1 imapserv 2935;StatMSSRetrMsg(77/571) 0/sec 0 ms [0] 0/0/0 0/0/0