# Design Choices & FAQ

This document answers some common questions about the design choices made in this project and the use of KubeVirt in a cloud-native environment.

### 1. Have you tried KubeVirt or similar tools?

Yes. This entire project serves as a hands-on lab and proof-of-concept for deploying and managing virtual machines using KubeVirt on a local Kubernetes cluster. We have explored multiple cluster backends (Minikube and Kind), multiple guest operating systems (Cirros, Fedora, Ubuntu, Windows), and different storage configurations (`containerDisk`, `DataVolume`).

### 2. When would you choose VMs over containers?

While containers are the default choice for modern, cloud-native applications, virtual machines still serve several critical use cases:

*   **Legacy Workloads:** The primary use case is for "lifting and shifting" legacy applications that are difficult or cost-prohibitive to containerize. These applications may have deep dependencies on a specific OS, require kernel-level access, or have a monolithic architecture that is not suited for microservices.
*   **Stronger Security Isolation:** VMs provide a hardware-level virtualization boundary, which is inherently stronger than the shared-kernel isolation provided by containers. For multi-tenant environments or highly sensitive workloads, a VM can provide an essential extra layer of security.
*   **Different Operating Systems:** KubeVirt allows you to run VMs with different operating systems (like Windows) on the same Kubernetes cluster as your Linux-based containers, providing a truly unified management plane.
*   **Kernel-Level Dependencies:** If an application requires specific kernel modules, `sysctl` settings, or a completely different kernel version, a VM is the only option, as containers share the host node's kernel.

### 3. How do you handle legacy workloads in a cloud-native environment?

KubeVirt is the primary strategy demonstrated in this project for handling legacy workloads. The approach is to treat the VM as an immutable artifact that can be managed by a cloud-native control plane.

By encapsulating a legacy application within a KubeVirt `VirtualMachine` object, we can:
*   **Orchestrate it with Kubernetes:** The legacy application immediately benefits from Kubernetes features like automated scheduling, self-healing (restarting a failed VM), and service discovery.
*   **Integrate with Cloud-Native Networking:** The VM lives on the pod network, allowing it to communicate directly with containers and be exposed via standard Kubernetes Services and Ingresses.
*   **Manage it via GitOps:** The VM's entire configuration is defined in a declarative YAML manifest, which can be stored in Git and managed through a CI/CD pipeline, just like any other Kubernetes application.

This provides a powerful bridge, allowing organizations to bring their entire portfolio of applications under a single management umbrella without needing to immediately re-architect every legacy component.
