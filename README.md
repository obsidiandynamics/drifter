Drifter
===
Distributed soak testing of Gradle builds. Drifter lets you soak builds across a pool of machines.

# Why Drifter
This tool is extremely handy for testing complex, distributed and/or concurrent applications that have non-deterministic failure modes that aren't easily captured by running a single pass of a test suite, however exhaustive it may be, and typically require several hours or days of soaking to ensure that the system performs as expected. Race conditions and dead locks are good examples of why soaking is necessary.

Drifter cuts down the testing time by soaking the build across a pool of machines, increasing the likelihood of observing a failure sooner. The pooled machines don't have to be the same - one can pool a soak across asymmetrically specced machines.

**Note:** Drifter isn't a tool to identify failures; rather it is a tool to amplify the likelihood of observing a failure, assuming that the failure is already observable, albeit infrequently, under the present test conditions. **Drifter isn't a substitute for a comprehensive set of tests with sufficient coverage of execution paths and timings.**

# How it works
1. Runs Ansible on the coordinating node, attaching to a pool of remote nodes (VMs, containers or physical boxes) via SSH;
2. Clones the target Git repo on the pooled nodes;
3. Uses a loop script to soak the Gradle build for a set period of time or until failure - in parallel, across all nodes in the pool;
4. In the event of a build failure, creates a tarball with the necessary reports on each pooled node and transports the tarballs back to the coordinating node;
5. If (and for as long as) the build passes on all nodes, the process is repeated until it's interrupted by the user.

# Getting started
Drifter takes the following environment variables:

* `DRIFTER_NODES`: a comma-separated list of nodes to orchestrate, with optional SSH ports - **mandatory**, e.g. `127.0.0.1:2200,127.0.0.1:2201`
* `DRIFTER_TARGET_REPO`: the target repo to test - **mandatory**, e.g. `https://github.com/obsidiandynamics/indigo`
* `DRIFTER_TARGET_BRANCH`: the branch to test - optional, defaults to `master`
* `DRIFTER_LOOP_ARGS`: arguments to the bundled `loop.sh` script - optional, defaults to `0 600 test`
  - The first argument is the number of seconds to pause between successive runs;
  - The second argument is the minimum number of seconds to soak for (the actual time will be somewhat longer, as `loop.sh` never interrupts a build midway);
  - The third and subsequent arguments are passed directly to the Gradle wrapper, along with `cleanTest`.
* `DRIFTER_LIB_BRANCH`: the branch of Drifter to use on the nodes - optional, defaults to `master`
* `DRIFTER_VERBOSE`: runs Ansible in verbose mode and enables Bash command tracing (`set -x`) in the playbook - optional, defaults to `false`

To print the environment variables without running the playbook:
```sh
./list-env.sh
```

## Example: running Drifter on Vagrant boxes
Starting Vagrant:
```sh
cd vagrant/java8-centos7-multi
vagrant up
```

Running the Drifter playbook:
```sh
. vagrant/env.sh
export DRIFTER_NODES=127.0.0.1:2200,127.0.0.1:2201
export DRIFTER_TARGET_REPO=https://github.com/obsidiandynamics/indigo
./play.sh
```

## Output
Failed outputs will be tarred and copied into `out`, under a subdirectory named `{address}-{port}`.

# Tools
## `loop.sh`
This is the actual soaking script that is run on the individual nodes. It's also handy to run on its own, when soaking a local build.

The script takes three or more arguments in the form:
```
loop.sh <sleep seconds> <duration seconds or -1 for indefinite> [gradle params]
```

The first two being the interval between successive tests and the total soak duration (in seconds). Passing `-1` as the second argument will soak indefinitely.

The third and subsequent arguments are passed to Gradle (requires `gradlew` in the project's root directory). In addition, `loop.sh` always passes `cleanTest` on your behalf, as the first argument to Gradle.

Example (assuming `drifter` is cloned alongside `mytestproject`):
```sh
cd mytestproject
../drifter/loop.sh 0 600 test
```

The output is stored in `build/looped`.
