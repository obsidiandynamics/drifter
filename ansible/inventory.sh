#!/bin/bash

# Optional parameters
if [ -z "$DRIFTER_TARGET_BRANCH" ]; then
  DRIFTER_TARGET_BRANCH="master"
fi

# Mandatory parameters
if [ -z "$ANSIBLE_HOSTS" -o \
     -z "$DRIFTER_TARGET_REPO" ]; then
  echo "One or more environment variables not set:"
  echo "  ANSIBLE_HOSTS: $ANSIBLE_HOSTS"
  echo "  DRIFTER_TARGET_REPO: $DRIFTER_TARGET_REPO"
  echo "  DRIFTER_TARGET_BRANCH: $DRIFTER_TARGET_BRANCH"
  exit 1
fi

dhs=""
repo_name=`echo $DRIFTER_TARGET_REPO | awk -F "/" '{print $NF}'`
drifter_home="~/.drifter"

echo -e "{\n"

id=0
for dh in $ANSIBLE_HOSTS; do
  df_host=`echo $dh | awk -F ":" '{print $1}'`
  df_port=`echo $dh | awk -F ":" '{print $2}'`
  if [ "$df_port" == "" ]; then
    df_port="22"
  fi

  df_alias="df_${df_host}_${df_port}"

cat << EOM
  "${df_alias}_group": {
    "hosts": [ "$df_alias" ],
    "vars": {
      "drifter_id": $id,
      "drifter_host": "$df_host",
      "ansible_host": "$df_host",
      "ansible_port": $df_port
    }
  },
EOM
  let id+=1
  dhs+="\"$df_alias\","
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
