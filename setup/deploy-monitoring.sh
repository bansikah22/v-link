#!/bin/bash
# Deploys the monitoring stack (Prometheus and Grafana)

set -e

echo "--- Deploying Monitoring Stack ---"

kubectl apply -f manifests/monitoring/prometheus.yaml
kubectl apply -f manifests/monitoring/grafana.yaml

echo ""
echo "--- Monitoring Stack Deployment Submitted ---"
echo "It may take a few minutes for the pods to be ready."
echo "Check status with: kubectl get pods -n monitoring"
echo ""
echo "To access Grafana, run:"
echo "kubectl port-forward svc/grafana -n monitoring 3000:3000"
echo "Then open http://localhost:3000 in your browser."
echo "(Default login: admin / admin)"
