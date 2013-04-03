Zabbix Remote Shell
===================

Pass commands to execute at remote Zabbix agent.

Copyright 2013 Michal Belica, <devel at beli sk>
Licenced under terms of Simplified (2-clause) BSD License

Features and limitations
------------------------

 * conveniently execute commands on remote server using only zabbix agent connection
 * keeps track of remote current working directory so you can use relative paths
 * remote zabbix agent has to be configured to allow executing commands
 * only stdout is forwarded, stderr ends up in zabbix agent log on the remote machine;
   you can use redirection to see stderr, e.g. `ls nonexistentpath 2>&1`
 * ZBX_NOTSUPPORTED is displayed when there is no output; this does not indicate error,
   the command may have finished correctly, just given no output
 * stdin is not redirected; the remote command has /dev/null on stdin; you cannot run
   interactive commands
 * longer running commands are killed after timeout defined in remote zabbix agent config
 * no remote environment is preserved between commands (except for the working directory);
   each command is executed in a new remote shell

Example
-------

```
$ ./zrsh.sh 
use: ./zrsh.sh <IP>

$ ./zrsh.sh 10.0.0.1
changing remote directory to '/'
zabbix@10.0.0.1:/$ ls
bin
boot
dev
etc
home
lib
lost+found
mnt
opt
proc
root
sbin
sys
tmp
usr
var
zabbix@10.0.0.1:/$ cd opt
changing remote directory to 'opt'
zabbix@10.0.0.1:opt$ cd zabbix
changing remote directory to 'zabbix'
zabbix@10.0.0.1:zabbix$ pwd
/opt/zabbix
zabbix@10.0.0.1:zabbix$ ls
bin
etc
sbin
```


