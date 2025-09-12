#!/bin/bash

echo "Starting Kubernetes deployment for Kafka microservices..."

# Check if minikube is running
if ! minikube status > /dev/null 2>&1; then
    echo "Starting Minikube..."
    minikube start --memory=4096 --cpus=2
fi

# Set docker environment to use minikube's docker daemon
echo "Setting up Docker environment..."
eval $(minikube docker-env)

# Build Docker images
echo "Building Producer Docker image..."
cd ../producer
docker build -t producer:latest .

echo "Building Consumer Docker image..."
cd ../consumer
docker build -t consumer:latest .

cd ../infrastructure

# Deploy Kafka first
echo "Deploying Kafka..."
kubectl apply -f kafka-deployment.yaml

# Wait for Kafka to be ready
echo "Waiting for Kafka to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/kafka

# Deploy Producer
echo "Deploying Producer..."
kubectl apply -f producer-deployment.yaml

# Deploy Consumer
echo "Deploying Consumer..."
kubectl apply -f consumer-deployment.yaml

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/producer
kubectl wait --for=condition=available --timeout=300s deployment/consumer

echo "Deployment complete!"
echo ""
echo "To check the status of your pods:"
echo "kubectl get pods"
echo ""
echo "To view logs:"
echo "kubectl logs -f deployment/producer"
echo "kubectl logs -f deployment/consumer"
echo "kubectl logs -f deployment/kafka"
echo ""
echo "To access the services:"
echo "kubectl port-forward service/producer-service 8081:8080"
echo "kubectl port-forward service/consumer-service 8082:8080"
