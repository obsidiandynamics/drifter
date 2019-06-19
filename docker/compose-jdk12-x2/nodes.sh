if [ $# = 1 ]; then
  host=$1
else
  host=localhost
fi

export DRIFTER_NODES=$host:2200,$host:2201
