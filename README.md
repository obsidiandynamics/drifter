Drifter
===
Virtualised soak testing of Gradle builds. Drifter lets you soak builds across a pool of VMs.

Requires the following environment variables:
`DRIFTER_HOSTS`
`DRIFTER_TARGET_REPO`
`DRIFTER_TARGET_BRANCH`

Running Ansible:
```sh
ansible-playbook playbook.yaml -i inventory.sh
```