#!/bin/bash

# Optional parameters
if [ -z $DRIFTER_TARGET_BRANCH ]; then
  DRIFTER_TARGET_BRANCH="master"
fi

# Mandatory parameters
if [ -z $DRIFTER_HOSTS || \
     -z $DRIFTER_TARGET_REPO ]; then
  echo "One or more environment variables not set:"
  echo "  DRIFTER_HOSTS: $DRIFTER_HOSTS"
  echo "  DRIFTER_TARGET_REPO: $DRIFTER_TARGET_REPO"
  echo "  DRIFTER_TARGET_BRANCH: $DRIFTER_TARGET_BRANCH"
  exit 1
fi

dhs=""
repo_name=`echo $DRIFTER_TARGET_REPO | awk -F "/" '{print $NF}'`
drifter_home="~/.drifter"

echo -e "{\n"

id=1
for dh in $DRIFTER_HOSTS
do
    dhs+="\"$dh\","

cat << EOM
    "drifter_$id": {
        "hosts": [ "$dh" ],
        "vars": {
            "ansible_port": 2222,
            "drifter_id": $id,
            "drifter_host": "$dh"
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
            "repo_name": "$repo_name",
            "drifter_home": "$drifter_home"
        }
    }
EOM

echo -e "}\n"
