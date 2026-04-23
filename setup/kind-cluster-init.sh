#!/bin/bash

# Exit on any error
set -e

echo "--- STEP 1: Creating Kind Cluster ---"
kind create cluster --config setup/kind-config.yaml

echo "--- STEP 2: Deploying KubeVirt Operator ---"
# Using a recent, stable version of the KubeVirt operator
KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Using KubeVirt version: $KUBEVIRT_VERSION"
kubectl apply -f "https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml"

echo "--- STEP 3: Deploying KubeVirt Custom Resource ---"
kubectl apply -f "https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml"

echo "--- STEP 4: Waiting for KubeVirt Components to be Ready ---"
# This can take several minutes as images are pulled
kubectl -n kubevirt wait kv kubevirt --for=condition=Available --timeout=10m

echo "--- STEP 5: Configuring for Software Emulation ---"
# This is required for running VMs on Kind, which does not support KVM
kubectl patch kubevirt kubevirt -n kubevirt --type=merge -p '{"spec":{"configuration":{"developerConfiguration":{"useEmulation":true}}}}'

echo "--- STEP 6: Deploying CDI Operator for Storage ---"
CDI_VERSION=$(curl -s https://api.github.com/repos/kubevirt/containerized-data-importer/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Using CDI version: $CDI_VERSION"
kubectl apply -f "https://github.com/kubevirt/containerized-data-importer/releases/download/${CDI_VERSION}/cdi-operator.yaml"
kubectl apply -f - <<EOF
apiVersion: cdi.kubevirt.io/v1beta1
kind: CDI
metadata:
  name: cdi
spec:
  config: {}
EOF

echo "--- STEP 7: Waiting for CDI Components to be Ready ---"
kubectl -n cdi wait cdi cdi --for=condition=Available --timeout=10m

echo "--- Kind Cluster Setup Complete ---"
echo "The cluster is ready for VM deployment."
