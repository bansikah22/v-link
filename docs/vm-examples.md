# Exploring the KubeVirt Test VM

Now that your Cirros test VM is running, here are a few commands you can run inside it to explore its capabilities and its unique position within the Kubernetes cluster.

First, connect to the VM's console from your host machine:
```bash
virtctl console v-link-vm
```
**Login:** `cirros`
**Password:** `password`  you might get some different default password then use that

---

### 1. Basic System & Network Checks

These commands confirm the VM is a standard, functioning Linux environment.

**Check IP Address:**
See the IP address the VM has received from the Kubernetes cluster network.
```bash
ip a
```

**Test Internet Connectivity:**
Ping a public IP address to confirm the VM can reach the outside world.
```bash
ping -c 3 8.8.8.8
```

**Test DNS Resolution:**
Ping a public domain name to confirm that DNS is working correctly from within the cluster.
```bash
ping -c 3 google.com
```

### 2. Interacting with the Kubernetes Cluster

This is where the power of KubeVirt becomes apparent. Your VM can interact with other Kubernetes services and pods as if it were just another pod.

**Ping the Kubernetes API Server:**
Every Kubernetes cluster has a default service named `kubernetes` that points to the API server. Your VM can resolve and ping this service name directly.

```bash
ping -c 3 kubernetes
```
This proves your VM is fully integrated into the cluster's DNS system.

### 3. Advanced Example: VM-to-Pod Communication

This example will prove that your VM can communicate directly with other applications (pods) running in the same cluster.

**Step 1 (On your host machine): Deploy a simple web server pod.**
We will deploy a simple Nginx web server. I have already created the manifest for you at `manifests/nginx-pod.yaml`.

Apply it from your host terminal:
```bash
kubectl apply -f manifests/nginx-pod.yaml
```

**Step 2 (On your host machine): Get the Nginx pod's IP address.**
Wait a few moments for the pod to start, then run this command to get its IP.
```bash
kubectl get pod nginx --template={{.status.podIP}}
```
This will print an IP address (e.g., `10.244.0.18`). Copy this IP address.

**Step 3 (Inside the VM console): Access the web server.**
Now, from inside the `virtctl console`, use the `curl` command with the IP address you just copied to access the default Nginx webpage.

```bash
# Replace the IP with the one you got from the previous command
curl 10.244.0.18
```

You should see the "Welcome to nginx!" HTML output. This demonstrates that your virtual machine, running a traditional OS, is communicating directly with a container over the internal Kubernetes network.
