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
- Access to a Kubernetes cluster
- Docker registry credentials (for CI/CD)

## Deployment

### 1. Deploy Dependencies

#### PostgreSQL

```sh
kubectl apply -f k8s/postgres/configmap-initdb.yaml
kubectl apply -f k8s/postgres/deployment.yaml
kubectl apply -f k8s/postgres/service.yaml
```
#### Redis (using Helm)
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install redis bitnami/redis -f k8s/redis/values.yaml
```
#### ZooKeeper (using Helm)
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install zookeeper bitnami/zookeeper -f k8s/zookeeper/values.yaml
```
#### Kafka (using Helm)
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install kafka bitnami/kafka -f k8s/kafka/values.yaml
```
### 2. Deploy Booking Platform Services
```sh
kubectl apply -f k8s/booking-service/deployment.yaml
kubectl apply -f k8s/booking-service/service.yaml
kubectl apply -f k8s/notification-service/deployment.yaml
kubectl apply -f k8s/notification-service/service.yaml
kubectl apply -f k8s/user-service/deployment.yaml
kubectl apply -f k8s/user-service/service.yaml
kubectl apply -f k8s/payment-service/deployment.yaml
kubectl apply -f k8s/payment-service/service.yaml
kubectl apply -f k8s/flight-service/deployment.yaml
kubectl apply -f k8s/flight-service/service.yaml
kubectl apply -f k8s/hotel-service/deployment.yaml
kubectl apply -f k8s/hotel-service/service.yaml
kubectl apply -f k8s/car-service/deployment.yaml
kubectl apply -f k8s/car-service/service.yaml
kubectl apply -f k8s/gateway/deployment.yaml
kubectl apply -f k8s/gateway/service.yaml
```
### 3. Setup Kafka Topics
```sh
kubectl exec -it <kafka-pod-name> -- kafka-topics.sh --create --topic booking-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
kubectl exec -it <kafka-pod-name> -- kafka-topics.sh --create --topic user-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
```
### 4. Verify Deployment
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
 

