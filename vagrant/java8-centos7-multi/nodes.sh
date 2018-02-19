if [ $# = 1 ]; then
  host=$1
else
  host=localhost
fi

export DRIFTER_NODES=$host:2200,$host:2201,$host:2202,$host:2203,$host:2204,$host:2205
