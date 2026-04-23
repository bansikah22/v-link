# Advanced Lab: Building a Custom VM Image with Docker

The Cirros VM is excellent for testing, but in a real-world scenario, you would want to run a standard OS like Ubuntu, Debian, or a custom-built image with your specific applications pre-installed.

This guide explains the concept and the high-level workflow for using Docker to build and manage these custom VM images, known as "container disks."

## The Concept: A Container as a Disk Carrier

The idea is not to *run* the VM inside the Docker container, but to use a container image as a convenient package to ship a virtual disk image (`.qcow2`, `.raw`, etc.) to your Kubernetes cluster.

When you define a `containerDisk` in your KubeVirt VM manifest, KubeVirt:
1.  Pulls the specified container image (e.g., `my-registry/my-ubuntu-vm:latest`).
2.  Starts a pod and extracts the disk file from the container's filesystem.
3.  Attaches this disk file to the QEMU process that runs the actual VM.

## Example Dockerfile for a Custom Ubuntu Image

## The Challenge: Customizing the Image

It is difficult to customize the contents of a disk image (e.g., to set a root password or install packages) within a standard `Dockerfile` build. Tools like `virt-customize` often fail due to missing kernel modules or permissions.

**The recommended solution is to use `cloud-init`**, just as we do with the test VMs. Prepare a generic OS disk image in your `Dockerfile`, and then inject user data and passwords via the `cloudInitNoCloud` volume in your `VirtualMachine` manifest. This separates the base image from its runtime configuration, which is a best practice.

## Example Dockerfile for a Custom Ubuntu Image

This simplified `Dockerfile` correctly focuses only on packaging the disk image. All user configuration should be handled in the `VirtualMachine` manifest.

```dockerfile
# Stage 1: Create the bootable disk image
FROM ubuntu:22.04 AS builder

# Install curl and the necessary CA certificates
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

# Download a generic, unmodified cloud image to use as a base
RUN curl -Lo /disk.img https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

# Stage 2: Create the final "carrier" container
FROM scratch

# Copy the disk image from the builder stage into the final container.
COPY --from=builder /disk.img /disk/disk.img
```

## The Workflow

1.  **Build the Image:**
    ```bash
    docker build -t my-registry/my-ubuntu-vm:v1 .
    ```

2.  **Load into Kind (for local testing):**
    ```bash
    kind load docker-image my-registry/my-ubuntu-vm:v1
    ```

3.  **Update the VM Manifest:**
    You would then create a manifest that points to your new container disk and provides `cloud-init` data to configure it on first boot.
    ```yaml
    apiVersion: kubevirt.io/v1
    kind: VirtualMachine
    # ...
    spec:
      template:
        # ...
        spec:
          domain:
            # ...
          volumes:
            - name: containerdisk
              containerDisk:
                image: my-registry/my-ubuntu-vm:v1
                imagePullPolicy: Never # Important for local images
            - name: cloudinitdisk
              cloudInitNoCloud:
                userData: |
                  #cloud-config
                  user: myuser
                  password: mypassword
                  chpasswd: { expire: False }
    ```

