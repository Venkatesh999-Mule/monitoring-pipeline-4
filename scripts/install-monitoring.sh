#!/bin/bash
echo "===== Setting up port forwards for monitoring ====="

MINIKUBE_IP=$(minikube ip)
echo "Minikube IP: $MINIKUBE_IP"

# Forward app
kubectl port-forward service/monitoring-app-service \
    8080:80 --address 0.0.0.0 &

# Forward Prometheus
kubectl port-forward service/prometheus-service \
    9090:9090 --address 0.0.0.0 &

# Forward Grafana
kubectl port-forward service/grafana-service \
    3000:3000 --address 0.0.0.0 &

echo "===== All ports forwarded ====="
echo "App        : http://your-ec2-ip:8080"
echo "Prometheus : http://your-ec2-ip:9090"
echo "Grafana    : http://your-ec2-ip:3000"
echo "Login      : admin / admin123"