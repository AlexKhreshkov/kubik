#!/bin/bash

echo "Cleaning up Kubernetes resources..."

# Delete deployments
kubectl delete -f consumer-deployment.yaml --ignore-not-found=true
kubectl delete -f producer-deployment.yaml --ignore-not-found=true
kubectl delete -f kafka-deployment.yaml --ignore-not-found=true

# Wait a bit for resources to be deleted
sleep 10

# Clean up any remaining resources
kubectl delete pods,services,deployments -l app=consumer --ignore-not-found=true
kubectl delete pods,services,deployments -l app=producer --ignore-not-found=true
kubectl delete pods,services,deployments -l app=kafka --ignore-not-found=true

echo "Cleanup complete!"
echo ""
echo "To check if all resources are deleted:"
echo "kubectl get all"
