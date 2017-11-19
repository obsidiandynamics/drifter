#!/bin/bash

cd $(dirname "$0")

CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'
echo_cmd="echo -e"
$echo_cmd $CYAN
./print-logo.sh
$echo_cmd
./list-env.sh
$echo_cmd $NC

cd ansible
while [ true ]; do
  if [ "$DRIFTER_VERBOSE" == "true" ]; then
    ansible-playbook playbook.yaml -i inventory.sh -vvv
  else
    ansible-playbook playbook.yaml -i inventory.sh
  fi
  exit_code=$?
  if [ "$exit_code" != 0 ]; then
    $echo_cmd "${RED}Ansible exited with code ${exit_code}.${NC}"
    cd ..
    node_dirs=`find out -mindepth 1 -maxdepth 1 -type d`
    for node_dir in $node_dirs; do
      if [ -f ${node_dir}/latest.tgz ]; then
        latest_timestamp=`cat ${node_dir}/latest-timestamp`
        target_file=${node_dir}/${latest_timestamp}.tgz
        echo "Storing output in $target_file"
        mv ${node_dir}/latest.tgz $target_file
      fi
    done
    exit 1;
  fi
done