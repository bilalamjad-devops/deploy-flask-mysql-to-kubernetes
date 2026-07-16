
### Kubernetes Lab Setup

### Prerequisites

* Docker Desktop is running

* Minikube is installed

* Kubectl is installed

### Step 1: Start Minikube

Bash

```
minikube status
minikube start --driver=docker
minikube status
```

### Step 2: Start the Application with Docker Compose

Bash

```
cp .env.example .env
docker compose up -d
```

Open the application and submit some data to verify that the Flask app and MySQL database are working.

### Step 3: Build and Push the Docker Image

Bash

```
docker images
docker tag flask-mysql:latest bilalamjaddevops/flask-mysql:latest
docker login
docker push bilalamjaddevops/flask-mysql:latest
```

### Step 4: Update the Kubernetes Deployment

Edit k8s/flask-deployment.yaml and set the image:

YAML

```
image: bilalamjaddevops/flask-mysql:latest
```

### Step 5: Deploy to Kubernetes

Bash

```
kubectl apply -f k8s/
```

### Step 6: Verify Resources

Bash

```
kubectl get deploy -n flask-mysql
kubectl get pods -n flask-mysql
kubectl get svc -n flask-mysql
kubectl get pvc -n flask-mysql
```

Expected result:

```
flask-app   1/1   Running
mysql       1/1   Running
```

### Step 7: Access the Application

Bash

```
minikube service flask-service -n flask-mysql
```

Minikube will open the application in your browser.

On Windows with the Docker driver, Minikube may create a temporary local URL such as:

```
http://127.0.0.1:17134
```

Keep the terminal open while accessing the application.

### Useful Commands

Get Minikube IP

Delete Minikube Cluster

`minikube ip``minikube delete`

### Project Flow

```
Flask Application
        ↓
Docker Image
        ↓
Docker Hub
        ↓
Kubernetes Deployment
        ↓
Flask Service (NodePort)
        ↓
Browser Access via Minikube
```

### Key Learning

* Start a Kubernetes cluster using Minikube

* Build and push a Docker image to Docker Hub

* Deploy a Flask + MySQL application on Kubernetes

* Use ConfigMap, Secret, and PVC resources

* Expose the application using a NodePort service

* Verify Kubernetes deployments, pods, services, and persistent storage

Lab Completed Successfully

You have deployed a Flask + MySQL application on Kubernetes using Minikube.
