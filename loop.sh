#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: loop.sh <sleep seconds> <duration seconds or -1 for indefinite> [gradle params]"
  echo "e.g. loop.sh 10 300 -x :test :indigo-examples:test --debug" 
  exit 1
fi

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
GREY='\033[0;90m'
NC='\033[0m'

sleep=$1
shift
duration=$1
shift
params="$*"

echo -e "${CYAN}Sleep:    ${sleep} s${NC}"
if [ $duration -eq -1 ]; then
  echo -e "${CYAN}Duration: indefinite${NC}"
  duration=2147483647
else
  echo -e "${CYAN}Duration: ${duration} s${NC}"
fi
echo -e "${CYAN}Params:   ${params}${NC}"

target_base=build/looped
start_time=`date +%s`

while [ true ]; do
  date=`date +%F-%H%M%S`
  ./gradlew cleanTest $params
  exit_code=$?
  if [ "${exit_code}" == "1" ]; then
    target_date=${target_base}/${date}
    build_dirs=`find . -type d | grep /build/reports\$`
    for build_dir in $build_dirs; do
      module_dir=$(dirname "$(dirname "$build_dir")")
      module_name=`echo $module_dir | awk -F "/" '{print $NF}'`
      target_dir=${target_date}/${module_name}
      mkdir -p $target_dir
      echo -e "${GREY}Copying $build_dir -> $target_dir ${NC}"
      cp -r $build_dir $target_dir
    done
    echo -e "${RED}Gradle process completed with code ${exit_code};${NC} saved test results in ${target_date}"
    exit 1
  elif [ "${exit_code}" == "130" ]; then
    echo -e "\n${YELLOW}Gradle process interrupted; exiting.${NC}"
    exit 130
  else
    echo -e "${GREEN}Gradle process completed with code ${exit_code}.${NC}"
  fi

  now=`date +%s`
  took=$((now - start_time))
  if [ $took -gt $duration ]; then
    echo -e "${GREEN}Took ${took} seconds.${NC}"
    exit 0
  else
    sleep $sleep
  fi
done
