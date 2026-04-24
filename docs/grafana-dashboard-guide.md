# Getting Started with Grafana Dashboards for KubeVirt

This guide will walk you through creating a simple Grafana dashboard to monitor the memory usage of your running virtual machines.

### Prerequisites

*   You have deployed the monitoring stack with `bash setup/deploy-monitoring.sh`.
*   You have an active port-forward to the Grafana service (`kubectl port-forward svc/grafana -n monitoring 3000:3000`).

### Step 1: Log in to Grafana

1.  Open your web browser and navigate to [http://localhost:3000](http://localhost:3000) (or whichever local port you used).
2.  Log in with the default credentials:
    *   **Username:** `admin`
    *   **Password:** `admin`
    (You will be prompted to change the password, which you can skip or complete).

### Step 2: Create a New Dashboard

1.  On the left-hand menu, click the **+** icon and select **Dashboard**.
2.  In the new dashboard view, click on **+ Add visualization**.

### Step 3: Configure the Panel

You will now be in the panel editor.

1.  **Data source:** In the query section at the bottom, ensure the `Prometheus` data source is selected (it should be the default).
2.  **Query:** In the "Metrics browser" input field, type `kubevirt_vmi_memory_used_bytes`. This is one of the many metrics that KubeVirt automatically exposes. You can see a graph begin to populate with data.
3.  **Legend (Optional but Recommended):** The default legend can be messy. To make it cleaner, in the "Legend" input field on the right, type `{{vmi}}`. This will make each line in the graph be labeled with the name of the Virtual Machine Instance (VMI).
4.  **Panel Title:** At the top right, give the panel a title, such as "VM Memory Usage".
5.  **Apply:** Click the **Apply** button at the top right to save the panel and return to the dashboard.

### Step 4: Save the Dashboard

1.  You will now see your new panel on the dashboard.
2.  Click the **Save** icon (floppy disk) at the top right of the dashboard screen.
3.  Give the dashboard a name, such as "KubeVirt Overview", and click **Save**.

### You're Done!

You have successfully created your first KubeVirt monitoring panel. You can now start and stop different VMs and watch their memory usage appear and disappear from the graph in real-time.

You can explore other available metrics by typing `kubevirt_` into the metrics browser. Some other interesting metrics to visualize include:
*   `kubevirt_vmi_network_traffic_bytes_total`
*   `kubevirt_vmi_storage_read_traffic_bytes_total`
*   `kubevirt_vmi_cpu_usage_seconds_total`
