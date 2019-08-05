#!/bin/sh
set -e

if [ -f /etc/hosts.original ]; then
  echo "Restoring original hosts file"
  mv /etc/hosts.original /etc/hosts
else
  echo "Preserving original hosts file"
  cp /etc/hosts /etc/hosts.original
fi

if [ "$DIND_HOST" != "" ]; then
  dind_ip=$(getent hosts $DIND_HOST | awk '{print $1}')
  echo "Docker in Docker host: $DIND_HOST; resolves to $dind_ip"
  echo "$dind_ip dind" >> /etc/hosts
  echo "export DOCKER_HOST=tcp://dind:2375" > ~/.bashrc
fi

PORT=22
LOG_FILE=sshd.log
/usr/sbin/sshd -p $PORT -E $LOG_FILE -u0
echo "SSH daemon running on port $PORT"
tail -f $LOG_FILE
