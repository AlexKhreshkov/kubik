# Kubernetes Infrastructure for Kafka Microservices

This directory contains Kubernetes manifests and deployment scripts for running the Producer and Consumer microservices with Kafka in a local Minikube cluster.

## Architecture

- **Kafka**: Message broker running on port 9092
- **Producer**: Spring Boot application that sends messages to Kafka topics
- **Consumer**: Spring Boot application that consumes messages from Kafka topics

## Prerequisites

1. **Minikube**: Install Minikube for local Kubernetes development
2. **kubectl**: Kubernetes command-line tool
3. **Docker**: Required for building images

## Quick Start

### 1. Deploy Everything

```bash
cd infrastructure
chmod +x deploy.sh
./deploy.sh
```

This script will:
- Start Minikube if it's not running
- Build Docker images for both microservices
- Deploy Kafka, Producer, and Consumer to Kubernetes
- Wait for all deployments to be ready

### 2. Verify Deployment

Check the status of all pods:
```bash
kubectl get pods
```

You should see all three pods in `Running` status:
```
NAME                        READY   STATUS    RESTARTS   AGE
consumer-xxxxxxxxx-xxxxx    1/1     Running   0          2m
kafka-xxxxxxxxx-xxxxx       1/1     Running   0          3m
producer-xxxxxxxxx-xxxxx    1/1     Running   0          2m
```

### 3. Access the Services

Forward ports to access the services locally:

**Producer Service:**
```bash
kubectl port-forward service/producer-service 8081:8080
```

**Consumer Service:**
```bash
kubectl port-forward service/consumer-service 8082:8080
```

### 4. Test the Setup

With port-forwarding active, you can test the microservices:

**Check Producer health:**
```bash
curl http://localhost:8081/ping
```

**Check Consumer health:**
```bash
curl http://localhost:8082/ping
```

**Send a message (if your producer has a message endpoint):**
```bash
curl -X POST http://localhost:8081/send -H "Content-Type: application/json" -d '{"message": "Hello Kafka!"}'
```

### 5. View Logs

Monitor the logs of your services:

**Producer logs:**
```bash
kubectl logs -f deployment/producer
```

**Consumer logs:**
```bash
kubectl logs -f deployment/consumer
```

**Kafka logs:**
```bash
kubectl logs -f deployment/kafka
```

## Configuration

### Kafka Configuration

- **Topic**: `helloTopic` (configured in your applications)
- **Bootstrap Servers**: `kafka-service:9092`
- **Auto-create topics**: Enabled

### Application Profiles

The applications use the `kubernetes` Spring profile when deployed, which:
- Connects to Kafka at `kafka-service:9092`
- Runs on port 8080 inside containers
- Uses appropriate Kafka serializers/deserializers

## Troubleshooting

### Pods not starting

1. Check pod status:
```bash
kubectl get pods
kubectl describe pod <pod-name>
```

2. Check logs:
```bash
kubectl logs <pod-name>
```

### Kafka connection issues

1. Verify Kafka service is running:
```bash
kubectl get service kafka-service
```

2. Check if Kafka is accessible from other pods:
```bash
kubectl exec -it deployment/producer -- nslookup kafka-service
```

### Resource issues

If pods are failing due to insufficient resources, you can:

1. Increase Minikube resources:
```bash
minikube stop
minikube start --memory=6144 --cpus=4
```

2. Reduce resource requests in the deployment files

## Cleanup

To remove all resources:

```bash
chmod +x cleanup.sh
./cleanup.sh
```

Or manually:
```bash
kubectl delete -f .
```

## Files Structure

```
infrastructure/
├── kafka-deployment.yaml      # Kafka deployment and service
├── producer-deployment.yaml   # Producer deployment and service
├── consumer-deployment.yaml   # Consumer deployment and service
├── deploy.sh                  # Automated deployment script
├── cleanup.sh                 # Cleanup script
└── README.md                  # This file
```

## Manual Deployment

If you prefer to deploy manually:

1. **Build images:**
```bash
eval $(minikube docker-env)
cd ../producer && docker build -t producer:latest .
cd ../consumer && docker build -t consumer:latest .
```

2. **Deploy in order:**
```bash
kubectl apply -f kafka-deployment.yaml
kubectl wait --for=condition=available --timeout=300s deployment/kafka
kubectl apply -f producer-deployment.yaml
kubectl apply -f consumer-deployment.yaml
```

## Scaling

To scale your microservices:

```bash
kubectl scale deployment producer --replicas=2
kubectl scale deployment consumer --replicas=3
```

Note: Only scale the microservices, not Kafka in this simple setup.
