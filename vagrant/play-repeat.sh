#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: play-repeat.sh <vagrant dir>"
  exit 1
fi

vagrant_dir=$1

cd $(dirname "$0")

while [ true ]; do
  cd $vagrant_dir
  vagrant destroy -f
  if [ $? -ne 0 ]; then
    echo "Error destroying VMs"
    exit 1
  fi

  vagrant up
  if [ $? -ne 0 ]; then
    echo "Error launching VMs"
     exit 1
  fi
  cd -

  ../play.sh
  if [ $? -ne 0 ]; then
    echo "Error running playbook"
    exit 1
  fi
done
