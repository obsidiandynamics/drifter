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

  vagrant up
  exitCode=$?
  if [ $exitCode -ne 0 ]; then
    echo "Error launching VMs (exit code $exitCode)"
     exit 1
  fi
  cd -

  ../play.sh
  exitCode=$?
  if [ $exitCode -ne 0 ]; then
    echo "Error running playbook (exit code $exitCode)"
    exit 1
  fi
done
