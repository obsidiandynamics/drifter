#!/bin/bash

while [ true ]; do
  ansible-playbook playbook.yaml -i inventory.sh -vvv
  exit_code=$?
  if [ "$exit_code" != 0 ]; then
    echo "Ansible exited with code ${exit_code}."
    exit 1;
  fi
done