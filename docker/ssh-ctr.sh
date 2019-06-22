#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Usage ssh-ctr.sh <container_index>"
  exit 1
fi

ctr_index=$1
port=$(($ctr_index + 2200))
ssh root@localhost -p $port -t -i ~/.vagrant.d/insecure_private_key "export PS1='\[\e[1;32m\]\u@ctr${ctr_index}~ssh#\[\e[0;0m\] ' && bash"