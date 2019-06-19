#!/bin/sh
set -e

PORT=22
LOG_FILE=sshd.log
/usr/sbin/sshd -p $PORT -E $LOG_FILE
echo "SSH daemon running on port $PORT"
tail -f $LOG_FILE
