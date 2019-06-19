# Sources Docker-specific environment variables.
#
# Usage:
# . ./env.sh
#

export ANSIBLE_ENVIRONMENT="docker"
export ANSIBLE_USER="root"
export ANSIBLE_SSH_PRIVATE_KEY_FILE="~/.vagrant.d/insecure_private_key"
export ANSIBLE_HOST_KEY_CHECKING="false"
