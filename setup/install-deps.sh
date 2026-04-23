#!/bin/bash

# Exit on error
set -e

# --- Helper function for checking commands ---
command_exists() {
    command -v "$1" &> /dev/null
}

# --- Install KVM and supporting tools ---
if dpkg -s qemu-kvm >/dev/null 2>&1; then
    echo "KVM and supporting tools are already installed."
else
    echo "Installing KVM and supporting tools..."
    sudo apt-get update
    sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils cpu-checker
fi

# --- Configure User Permissions ---
if ! groups $USER | grep -q '\blibvirt\b'; then
    echo "Adding user $USER to the libvirt group..."
    sudo adduser $USER libvirt
fi

if ! groups $USER | grep -q '\bkvm\b'; then
    echo "Adding user $USER to the kvm group..."
    sudo adduser $USER kvm
fi

echo "Restarting libvirtd service to apply changes..."
sudo systemctl restart libvirtd.service
echo "Note: A full logout/login may still be required for all group changes to take effect."


# --- Install Minikube ---
if command_exists minikube; then
    echo "Minikube is already installed."
else
    echo "Installing Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    sudo install minikube /usr/local/bin/
fi

# --- Install kubectl ---
if command_exists kubectl; then
    echo "kubectl is already installed."
else
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo install kubectl /usr/local/bin/
fi

# --- Install virtctl ---
if command_exists virtctl; then
    echo "virtctl is already installed."
else
    echo "Installing virtctl..."
    KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -Lo virtctl https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/virtctl-${KUBEVIRT_VERSION}-linux-amd64
    chmod +x virtctl
    sudo install virtctl /usr/local/bin/
fi

# --- Install Kind ---
if command_exists kind; then
    echo "kind is already installed."
else
    echo "Installing kind..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
    chmod +x ./kind
    sudo install ./kind /usr/local/bin/
fi

echo "Dependency check and installation complete."
