# Project V-Link (Virtualization-Link)

Welcome to Project V-Link, a blueprint for running virtual machines on Kubernetes using KubeVirt. This project provides the necessary scripts and manifests to set up a complete local development environment using **Kind (Kubernetes in Docker)**.

## About KubeVirt

KubeVirt is an open-source project that extends Kubernetes to manage virtual machines alongside containers. It provides a unified platform for orchestrating both modern, containerized workloads and traditional, VM-based applications. For a more detailed explanation of the architecture, see the [KubeVirt Explained](docs/kubevirt-explained.md) document.

*   **Official Website:** [https://kubevirt.io/](https://kubevirt.io/)
*   **Official Kind Quickstart:** [https://kubevirt.io/quickstart_kind/](https://kubevirt.io/quickstart_kind/)

## Environment Requirements

*   **Host OS:** A Linux distribution that can run Docker (Ubuntu 22.04/24.04 recommended).
*   **Tools:** Docker, `curl`, and standard shell utilities.
*   **RAM:** 8GB recommended.
*   **Disk:** 20GB+ of disk space.

## Setup and Usage

## Setup and Usage

This project uses **Kind** to create a local Kubernetes cluster inside Docker. This method is highly reliable and works on most systems. It uses software emulation for the VMs, which is slower than hardware-assisted virtualization but is perfect for development and testing.

### Quick Start (One-Liner)

For a fast setup, you can run all the preparation and initialization steps with a single command. You will be prompted for your password for the host preparation step.
```bash
bash setup/prepare-host.sh && bash setup/install-deps.sh && bash setup/kind-cluster-init.sh
```

### Manual Step-by-Step

#### Step 1: Prepare the Host System
**This is a critical first step.** The KubeVirt components require higher system limits than a default OS installation provides. Run the following script to increase these limits.
```bash
bash setup/prepare-host.sh
```

#### Step 2: Install Dependencies
Run the `install-deps.sh` script. This will check for and install all the necessary command-line tools, including `kubectl`, `virtctl`, and `kind`.
```bash
bash setup/install-deps.sh
```

#### Step 3: Initialize the Kind Cluster
Run the `kind-cluster-init.sh` script. This will:
1.  Create a new Kind cluster.
2.  Deploy the official KubeVirt and CDI operators.
3.  Automatically enable software emulation.

This process can take **5-10 minutes** as it downloads all the necessary container images for Kubernetes and KubeVirt.
```bash
bash setup/kind-cluster-init.sh
```

### Step 4: Deploy the Test VM
Once the cluster is ready, use the `deploy.sh` script to create a test virtual machine. The VM uses a very small Cirros cloud image, so it will start very quickly.
```bash
bash setup/deploy.sh
```

### Step 2: Install Dependencies

Run the `install-deps.sh` script. This will check for and install all the necessary command-line tools, including `kubectl`, `virtctl`, and `kind`.

```bash
bash setup/install-deps.sh
```

### Step 3: Initialize the Kind Cluster

Run the `kind-cluster-init.sh` script. This will:
1.  Create a new Kind cluster.
2.  Deploy the official KubeVirt and CDI operators.
3.  Automatically enable software emulation.

This process can take **5-10 minutes** as it downloads all the necessary container images for Kubernetes and KubeVirt.

```bash
bash setup/kind-cluster-init.sh
```

### Step 4: Deploy the Test VM

Once the cluster is ready, use the `deploy.sh` script to create a test virtual machine. The VM uses a very small Cirros cloud image, so it will start very quickly.

```bash
bash setup/deploy.sh
```

### Step 5: Connect to the VM

After a minute or so, you can connect to the VM's console using `virtctl`.

```bash
virtctl console v-link-vm
```
*   **Login:** `cirros`
*   **Password:** `password`

(Note: To log out of the Cirros console, use the key combination `Ctrl+]`)

### (Optional) Step 6: Deploy Monitoring Stack

This project includes a basic monitoring stack with Prometheus and Grafana to visualize KubeVirt metrics.

1.  **Deploy Prometheus & Grafana:**
    ```bash
    bash setup/deploy-monitoring.sh
    ```

2.  **Access Grafana:**
    Wait a few minutes for the pods to start, then set up a port-forward to the Grafana service.
    ```bash
    kubectl port-forward svc/grafana -n monitoring 3000:3000
    ```
    You can now open [http://localhost:3000](http://localhost:3000) in your browser.

    **Note:** If you get an "address already in use" error, it means another service on your machine is using port 3000. You can map to a different local port by changing the command, for example, to use port 3001:
    ```bash
    kubectl port-forward svc/grafana -n monitoring 3001:3000
    ```
    Then, you would access Grafana at [http://localhost:3001](http://localhost:3001).

    The default login is `admin` / `admin`. The Prometheus data source will be pre-configured. You can explore KubeVirt metrics by creating a new dashboard and querying metrics like `kubevirt_vmi_memory_used_bytes`.

### Deploying Other VMs

This project also includes manifests for other types of VMs. You can deploy them using `kubectl apply`.

#### Fedora VM
```bash
kubectl apply -f manifests/05-fedora-vm.yaml
```
- **Connect:** `virtctl console v-link-vm-fedora`
- **Login:** `fedora` / `password`

#### Custom Ubuntu VM
This requires building a local Docker image first. See the [Advanced Guide](docs/advanced-custom-images.md) for details.
```bash
kubectl apply -f manifests/04-ubuntu-custom-vm.yaml
```
- **Connect:** `virtctl console v-link-vm-ubuntu`
- **Login:** `ubuntu` / `password`

#### Windows Server 2019 VM (Requires Authentication)
**Note:** The official Windows container disk requires authentication with a `quay.io` account. The manifest `manifests/06-windows-vm.yaml` is commented out by default. To use it, you must first run `docker login quay.io` on your host machine and then uncomment the manifest file.
<!--
**Warning:** This image is very large (>10GB) and will take a long time to download the first time.
```bash
kubectl apply -f manifests/06-windows-vm.yaml
```
- **Connect:** Windows does not have a serial console login. Access is typically via RDP, which requires setting up a Kubernetes service (not included in this project). You can verify it is running with `kubectl get vmi v-link-vm-windows`.
- **Login:** Administrator / `Password123!`
-->

### Managing the VMs

*   **Stop the VM:** `virtctl stop v-link-vm`
*   **Start the VM:** `virtctl start v-link-vm`
*   **Delete the VM:** `kubectl delete vm v-link-vm`
*   **Destroy the entire cluster:** `kind delete cluster`

### Exploring the VM

For a hands-on guide to using the VM and seeing how it interacts with the Kubernetes cluster, see the [VM Examples Document](docs/vm-examples.md).

For a more advanced guide on how to build your own custom VM images using Docker, see the [Advanced: Custom Images Guide](docs/advanced-custom-images.md).

For answers to common questions about KubeVirt and the design of this project, see the [Design Choices & FAQ](docs/design-choices.md).

---

## License

This project is licensed under the [Apache 2.0 License](LICENSE).
