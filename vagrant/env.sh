# Sources Vagrant-specific environment variables.
#
# Usage:
# . ./env.sh
#

export ANSIBLE_USER="vagrant"
export ANSIBLE_SSH_PRIVATE_KEY_FILE="~/.vagrant.d/insecure_private_key"
export ANSIBLE_HOST_KEY_CHECKING="false"
export ANSIBLE_ENVIRONMENT="vagrant"
export ANSIBLE_APPLICATION="drifter"
