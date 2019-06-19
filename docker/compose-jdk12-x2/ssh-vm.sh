#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Usage ssh-vm.sh <vm_index>"
  exit 1
fi

vm_index=$1
port=$(($vm_index + 2200))
#ssh root@localhost -p $port -t -i ~/.vagrant.d/insecure_private_key "export PS1=\"root@vm${vm_index}# \" && bash"
ssh root@localhost -p $port -t -i ~/.vagrant.d/insecure_private_key "export PS1='\[\e[1;32m\]\u@vm${vm_index}~ssh# ' && bash"