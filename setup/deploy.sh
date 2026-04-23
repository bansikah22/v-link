#!/bin/bash

# Exit on any error
set -e

echo "--- Deploying Test VM ---"

kubectl apply -f manifests/03-cirros-test-vm.yaml

echo "--- Deployment Submitted ---"
echo "The VM will be created shortly. You can check its status with 'kubectl get vm v-link-vm'."
echo "Once the VM is running, connect to it with: virtctl console v-link-vm"
echo "(Login with user 'cirros' and password 'password')"
