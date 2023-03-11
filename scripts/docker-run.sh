#!/bin/bash

set -e

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck source=/dev/null
[[ -f ".env" ]] && source ".env"

# shellcheck source=/dev/null
source "${DIR}/docker-build.sh"

docker stop "proxmox-k8s-iac" || true

docker run -it --rm -d \
  --name "proxmox-k8s-iac" \
  --env-file ".env" \
  -v "$HOME/.ssh:/root/.ssh" \
  -v "$(pwd):/srv" \
  chrisleekr/proxmox-k8s-iac:latest

echo "*******"
echo "You can now access to the container by executing the following command:"
echo " $ docker exec -it \"proxmox-k8s-iac\" /bin/ash"
echo "If you ran 'npm run docker:exec', you should see the container bash at /srv."
echo "*******"
