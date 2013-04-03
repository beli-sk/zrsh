#!/bin/bash
#
# Zabbix Remote Shell - pass commands to execute at remote Zabbix agent
#
# Copyright 2013 Michal Belica <devel@beli.sk>
# Licenced under terms of Simplified (2-clause) BSD License
#

IP=$1
RCWD=""
BASERCWD=""

function rcmd {
  # execute remote command
  if [[ -n "$RCWD" ]] ; then
    precmd="cd $RCWD ; "
  else
    precmd=""
  fi
  /opt/zabbix/bin/zabbix_get -s "$IP" -k "system.run[${precmd}$1]"
  return $?
}

function lcmd {
  # try to parse command
  if [[ "$1" == "cd" ]] ; then
    echo "changing remote directory to '$2'"
    if ret=$(rcmd "cd $2 && pwd || echo FAIL") && [[ "$ret" != "FAIL" ]]  ; then
      RCWD="$ret"
      BASERCWD=$( basename "$RCWD" )
    else
      echo "failed to change remote directory"
      return 1
    fi
    return 0
  fi
  # no local command recognized
  return 2
}

if [[ -z "$IP" ]] ; then
  echo "use: $0 <IP>" >&2
  exit 1
fi

lcmd cd / || exit 1

while read -p "zabbix@${IP}:${BASERCWD}\$ " line ; do
  if [[ -z "$line" ]] ; then
    break
  fi
  lcmd $line
  if [[ $? -eq 2 ]] ; then
    # local command not recognized, pass to remote
    rcmd "$line"
  fi
done
echo
