Drifter
===
Virtualised soak testing of Gradle builds. Drifter lets you soak builds across a pool of VMs.

Requires the following environment variables:

* `DRIFTER_HOSTS`: mandatory, e.g. `127.0.0.1:2222,127.0.0.1:2223`
* `DRIFTER_TARGET_REPO`: mandatory, e.g. `https://github.com/obsidiandynamics/indigo`
* `DRIFTER_TARGET_BRANCH`: optional, defaults to `master`
* `DRIFTER_LOOP_ARGS`: optional, defaults to `0 600`

**Example:** running Drifter with Vagrant boxes
```sh
. ansible/env-vagrant.sh
ansible/loop-playbook.sh
```

To print the environment variables without running the playbook:
```
ansible/list-env.sh
```