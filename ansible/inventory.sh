#!/bin/bash

if [ -z $DRIFTER_HOSTS ]; then
  echo "DRIFTER_HOSTS not set"
  exit 1
fi

dhs=""

echo -e "{\n"

id=1
for dh in $DRIFTER_HOSTS
do
    dhs+="\"$dh\","

cat << EOM
    "drifter_$id": {
        "hosts": [ "$dh" ],
        "vars": {
            "ansible_port": 2222
        }
    },
EOM
    let id+=1
done

cat << EOM
    "drifter_hosts": {
        "hosts": [ ${dhs%?} ],
        "vars": {
            "ansible_connection": "ssh",
            "ansible_user": "$ANSIBLE_USER",
            "ansible_ssh_private_key_file": "$ANSIBLE_SSH_PRIVATE_KEY_FILE",
            "target_repo": "$DRIFTER_TARGET_REPO",
            "target_branch": "$DRIFTER_TARGET_BRANCH",
        }
    }
EOM

echo -e "}\n"
