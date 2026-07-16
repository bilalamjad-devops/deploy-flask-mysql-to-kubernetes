This is a cleaner and simpler version for your README.md. It keeps the same workflow but removes unnecessary details and makes the steps easier to follow.

### Kubernetes Lab Setup (Minikube + Docker Driver)

### Prerequisites

* Docker Desktop is running.

* Minikube is installed.

* Kubernetes manifests are available in the k8s/ directory.

### Step 1: Start Minikube

Check Minikube status

bash

minikube status

Start the cluster

bash

minikube start --driver=docker

Verify the cluster

bash

minikube status

### Step 2: Create the Environment File

bash

cp .env.example .env

### Step 3: Test the Application with Docker Compose

bash

docker compose up -d

Open the application and submit some data to verify that Flask and MySQL are working correctly.

### Step 4: Push the Flask Image to Docker Hub

Check available images:

bash

docker images

Tag the image:

bash

docker tag flask-mysql:latest bilalamjaddevops/flask-mysql:latest

Login to Docker Hub:

bash

docker login

Push the image:

bash

docker push bilalamjaddevops/flask-mysql:latest

### Step 5: Update Kubernetes Deployment

In flask-deployment.yaml, set the image to:

yaml

image: bilalamjaddevops/flask-mysql:latest

### Step 6: Deploy to Kubernetes

bash

kubectl apply -f k8s/

### Step 7: Verify Resources

Deployments:

bash

kubectl get deploy -n flask-mysql

Pods:

bash

kubectl get pods -n flask-mysql

Persistent Volume Claim:

bash

kubectl get pvc -n flask-mysql

### Step 8: Access the Application

bash

minikube service flask-service -n flask-mysql

Minikube will open the application in your browser.

Example output:

[http://127.0.0.1:17134](http://127.0.0.1:17134)

Note: When using the Docker driver on Windows, the terminal must remain open while the service tunnel is running.

### Useful Commands

| Purpose            | Command                                        |
| ------------------ | ---------------------------------------------- |
| Get Minikube IP    | minikube ip                                    |
| Check pod logs     | kubectl logs <pod-name> -n flask-mysql         |
| Describe a pod     | kubectl describe pod <pod-name> -n flask-mysql |
| Delete the cluster | minikube delete                                |

### Project Flow

Start Minikube

Configure .env

Test with Compose

Push Image

Update YAML

Apply Manifests

Verify Pods

Access App

### Key Learning

* Started a local Kubernetes cluster using Minikube.

* Built and pushed a Docker image to Docker Hub.

* Used ConfigMap and Secret for application configuration.

* Deployed Flask and MySQL on Kubernetes.

* Exposed the Flask application using a NodePort Service.

* Verified Deployments, Pods, Services, and PVCs using kubectl.
