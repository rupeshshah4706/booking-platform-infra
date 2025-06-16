# Ticket Booking Platform
## booking-platform-infra

Infrastructure as Code for deploying the Booking Platform and its dependencies on Kubernetes.

## Overview

This repository contains Kubernetes manifests, custom Helm charts, and automation scripts to deploy the Booking Platform microservices and their dependencies (PostgreSQL, Redis, ZooKeeper, Kafka) in a cloud-native environment.

- **Tech Stack:** Java, Spring Boot, Maven
- **Dependencies:** PostgreSQL, Redis, ZooKeeper, Kafka

## Components

- **k8s/**: Raw Kubernetes manifests for all services and dependencies.
- **helm/**: Custom Helm charts for each component (for advanced/templated deployments).
- **scripts/**: Helper scripts (e.g., Kafka topic setup).
- **.github/workflows/**: CI/CD GitHub Actions workflows.

## Prerequisites

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) or access to a Kubernetes cluster
- Docker registry credentials (for CI/CD)

## Minikube Setup

### Installation

```sh
# macOS (using Homebrew)
brew install minikube

# macOS (using direct download)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

### Starting Minikube

```sh
# Start with sufficient resources for all components
minikube start --cpus=4 --memory=8192 --disk-size=20g

# Enable ingress addon (optional)
minikube addons enable ingress

# Verify minikube is running
minikube status
```

### Configure kubectl to use Minikube

```sh
kubectl config use-context minikube
```

## Deployment

### 1. Deploy Dependencies

#### PostgreSQL

```sh
kubectl apply -f k8s/postgres/configmap-initdb.yaml
kubectl apply -f k8s/postgres/deployment.yaml
kubectl apply -f k8s/postgres/service.yaml
```
#### Redis
```sh
# Using our simplified templates
helm install redis ./k8s/redis
```
#### ZooKeeper
```sh
# Using our simplified templates
helm install zookeeper ./k8s/zookeeper
```
#### Kafka
```sh
# Using our simplified templates
helm install kafka ./k8s/kafka
# Note: The kafka-setup-job will automatically create necessary topics and consumer groups
```

### 2. Deploy Application Services

#### Booking Service
```sh
# Deploy booking service
kubectl apply -f k8s/booking/deployment.yaml
kubectl apply -f k8s/booking/service.yaml
```

#### Booking Processor
```sh
# Deploy booking processor
kubectl apply -f k8s/booking-processor/deployment.yaml
kubectl apply -f k8s/booking-processor/service.yaml
```

### 3. Kafka Topics and Consumer Groups
Topics and consumer groups are automatically created by the Kafka setup job that runs after installation. You can verify they were created with:

```sh
# List topics
kubectl exec -it $(kubectl get pods -l app=kafka -o jsonpath='{.items[0].metadata.name}') -- /opt/bitnami/kafka/bin/kafka-topics.sh --list --bootstrap-server kafka:9092

# List consumer groups
kubectl exec -it $(kubectl get pods -l app=kafka -o jsonpath='{.items[0].metadata.name}') -- /opt/bitnami/kafka/bin/kafka-consumer-groups.sh --bootstrap-server kafka:9092 --list
```
### 3. Verify Deployment
```sh
kubectl get pods
kubectl get services
```
## CI/CD
This repository includes GitHub Actions workflows for CI/CD:
- **Build and Test**: Runs tests and builds Docker images for each service.
- **Deploy**: Deploys the latest images to the Kubernetes cluster.
- **Release**: Tags and releases Docker images to the registry.
- **Helm Chart Linting**: Validates Helm charts for syntax and best practices.
- **Kubernetes Manifests Linting**: Validates Kubernetes manifests for syntax and best practices.
- **Security Scanning**: Scans Docker images for vulnerabilities using Trivy.
- **Code Quality**: Runs SonarQube analysis for code quality and security issues.
- **Dependency Scanning**: Checks for outdated dependencies using Dependabot.
- **Documentation Generation**: Generates API documentation using Swagger/OpenAPI.
- **Performance Testing**: Runs performance tests using JMeter or Gatling.
- **Load Testing**: Runs load tests using Locust or similar tools.
- **Integration Testing**: Runs integration tests against the deployed services.
- **End-to-End Testing**: Runs end-to-end tests using Cypress or Selenium.
- **Monitoring and Alerting**: Sets up monitoring and alerting using Prometheus and Grafana.
- **Logging**: Sets up centralized logging using ELK stack (Elasticsearch, Logstash, Kibana) or EFK stack (Elasticsearch, Fluentd, Kibana).
- **Backup and Restore**: Sets up backup and restore procedures for databases and persistent volumes.
- **Disaster Recovery**: Implements disaster recovery procedures for critical services.
- **Scaling**: Implements horizontal and vertical scaling for services.
- **Security**: Implements security best practices such as network policies, RBAC, and secrets management.
- **Compliance**: Implements compliance checks for GDPR, HIPAA, or other regulations.
- **Documentation**: Maintains documentation for the infrastructure, deployment procedures, and service APIs.
- **Versioning**: Follows semantic versioning for services and Helm charts.
 

