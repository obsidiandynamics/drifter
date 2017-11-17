Drifter
===
Virtualised soak testing of Gradle builds. Drifter lets you soak builds across a pool of VMs.

Takes the following environment variables:

* `DRIFTER_NODES`: mandatory, e.g. `127.0.0.1:2200,127.0.0.1:2201`
* `DRIFTER_TARGET_REPO`: mandatory, e.g. `https://github.com/obsidiandynamics/indigo`
* `DRIFTER_TARGET_BRANCH`: optional, defaults to `master`
* `DRIFTER_LOOP_ARGS`: optional, defaults to `0 600 test`
* `DRIFTER_LIB_BRANCH`: optional, defaults to `master`
* `DRIFTER_VERBOSE`: optional, defaults to `false`

To print the environment variables without running the playbook:
```sh
./list-env.sh
```

# Example: running Drifter on Vagrant boxes
Starting Vagrant:
```sh
cd vagrant/java8-centos7-multi
vagrant up
```

Running the playbook:
```sh
. vagrant/env.sh
export DRIFTER_NODES=127.0.0.1:2200,127.0.0.1:2201
export DRIFTER_TARGET_REPO=https://github.com/obsidiandynamics/indigo
./play.sh
```

# Output
Failed outputs will be tarred and copied into `out`, under a subdirectory named `{address}-{port}`.