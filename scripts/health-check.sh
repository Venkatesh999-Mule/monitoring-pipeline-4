#!/bin/bash

MINIKUBE_IP="192.168.49.2"

echo "===== Health Check Starting ====="

# Check main app
APP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    --connect-timeout 5 \
    "http://${MINIKUBE_IP}:30080/health")

# Check Prometheus
PROM_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    --connect-timeout 5 \
    "http://${MINIKUBE_IP}:30090/-/healthy")

echo "App status    : $APP_STATUS"
echo "Prometheus    : $PROM_STATUS"

if [ "$APP_STATUS" == "200" ] && [ "$PROM_STATUS" == "200" ]; then
    echo "===== All services HEALTHY ====="
    exit 0
else
    echo "===== Health check FAILED ====="
    exit 1
fi