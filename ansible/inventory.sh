#!/bin/bash

# Optional parameters
if [ -z "$DRIFTER_TARGET_BRANCH" ]; then
  export DRIFTER_TARGET_BRANCH="master"
fi
if [ -z "$DRIFTER_LOOP_ARGS" ]; then
  export DRIFTER_LOOP_ARGS="0 600 test --info --stacktrace --no-daemon"
fi
if [ -z "$DRIFTER_LIB_BRANCH" ]; then
  export DRIFTER_LIB_BRANCH="master"
fi
if [ -z "$DRIFTER_VERBOSE" ]; then
  export DRIFTER_VERBOSE="false"
fi
if [ -z "$DRIFTER_TARGET_REPO_SUBDIR" ]; then
  export DRIFTER_TARGET_REPO_SUBDIR=""
fi

# Mandatory parameters
if [ -z "$DRIFTER_NODES" -o \
     -z "$DRIFTER_TARGET_REPO" ]; then
  echo "One or more environment variables not set:"
  ../list-env.sh
  exit 1
fi

dhs=""
repo_name=`echo $DRIFTER_TARGET_REPO | awk -F "/" '{print $NF}'`
drifter_home="~/.drifter"

echo -e "{\n"

id=0
drifter_nodes_array=(`echo $DRIFTER_NODES | sed 's/,/ /g'`)
for dh in ${drifter_nodes_array[@]}; do
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
      "lib_branch": "$DRIFTER_LIB_BRANCH",
      "target_repo": "$DRIFTER_TARGET_REPO",
      "target_branch": "$DRIFTER_TARGET_BRANCH",
      "repo_name": "$repo_name",
      "target_repo_subdir": "$DRIFTER_TARGET_REPO_SUBDIR",
      "drifter_home": "$drifter_home",
      "loop_args": "$DRIFTER_LOOP_ARGS",
      "verbose": "$DRIFTER_VERBOSE"
    }
  }
EOM

echo -e "}\n"
