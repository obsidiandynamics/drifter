#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Usage: save-env.sh <profile>"
  exit 1
fi

profile=$1

mkdir -p env
target_file=env/${profile}

if [ -e $target_file ]; then
  echo "File $target_file already exists; delete it before attempting to save with this profile name."
  exit 1
fi

echo "export DRIFTER_NODES=\"${DRIFTER_NODES}\"" >> $target_file
echo "export DRIFTER_TARGET_REPO=\"${DRIFTER_TARGET_REPO}\"" >> $target_file
echo "export DRIFTER_TARGET_BRANCH=\"${DRIFTER_TARGET_BRANCH}\"" >> $target_file
echo "export DRIFTER_LOOP_ARGS=\"${DRIFTER_LOOP_ARGS}\"" >> $target_file
echo "export DRIFTER_LIB_BRANCH=\"${DRIFTER_LIB_BRANCH}\"" >> $target_file
echo "export DRIFTER_VERBOSE=\"${DRIFTER_VERBOSE}\"" >> $target_file
echo "export DRIFTER_DURATION=\"${DRIFTER_DURATION}\"" >> $target_file


echo "Exports saved to $target_file. Load with command '. $target_file'."
