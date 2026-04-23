#!/bin/bash

# This script prepares the host machine to run KubeVirt on Kind by increasing
# system limits that can cause the virt-handler pod to crash.

# Exit on any error
set -e

echo "--- Applying required host system settings for KubeVirt on Kind ---"

echo "Increasing inotify watches limit..."
# The virt-handler needs to watch many files for certificate changes.
# The default limit is often too low.
sudo sysctl fs.inotify.max_user_watches=1048576

echo "Increasing inotify instances limit..."
sudo sysctl fs.inotify.max_user_instances=8192

echo "--- Host preparation complete ---"
echo "You can now run the 'kind-cluster-init.sh' script."
