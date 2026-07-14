# Stage 3: Deploying Flask + MySQL to Kubernetes

> Series: Stage 1: [containerize-flask-mysql-application](https://github.com/bilalamjad-devops/containerize-flask-mysql-application) → Stage 2: [orchestrate-flask-mysql-with-docker-compose](https://github.com/bilalamjad-devops/orchestrate-flask-mysql-with-docker-compose) → **Stage 3 (this repo): Kubernetes** → Stage 4: scale-and-expose-flask-app-on-kubernetes → Stage 5: CI/CD → Stage 6: GitOps

## Problem

`docker-compose` (Stage 2) solved networking and persistence declaratively,
but it's still fundamentally single-machine:

- If the host machine goes down, the entire app goes down — no redundancy.
- If a container crashes, compose doesn't automatically restart it in the
  same self-healing way a real orchestrator does.
- There's no concept of running multiple replicas of the app for
  availability or load distribution.
- It isn't how real production systems are actually run at any meaningful
  scale — compose is a local/dev tool, not a cluster orchestrator.

## Solution

Deploy the same application to Kubernetes, translating each compose concept
into its cluster-native equivalent:

| docker-compose | Kubernetes | Purpose |
|---|---|---|
| `services:` | Deployment | Defines desired running state; self-heals if a pod dies |
| service name DNS | Service | Internal DNS + stable network identity for pods |
| plain `environment:` | ConfigMap | Non-sensitive configuration |
| plain `environment:` (passwords) | Secret | Sensitive values, kept separate from config |
| named `volumes:` | PersistentVolumeClaim | Durable storage, survives pod rescheduling |

**Scope of this stage, on purpose:** just Deployment, Service, ConfigMap,
Secret, and PVC. Ingress, autoscaling, and rolling-update strategy are
Stage 4's job (`scale-and-expose-flask-app-on-kubernetes`) — kept separate
so this stage stays focused on one new concept: cluster-based orchestration.

## Prerequisites (all free)

- Docker Desktop (already set up)
- `kind` (Kubernetes in Docker) — install via:
  ```bash
  # Windows (with Chocolatey)
  choco install kind

  # or download the binary directly:
  # https://kind.sigs.k8s.io/docs/user/quick-start/#installation
  ```
- `kubectl` — install via:
  ```bash
  choco install kubernetes-cli
  ```

This runs a real (if small) Kubernetes cluster entirely inside Docker on
your machine — no cloud account, no cost.

## Step-by-step: run this locally

### 1. Create the local cluster

```bash
kind create cluster --name flask-mysql-lab --config kind-config.yaml
```

Verify it's up:
```bash
kubectl cluster-info --context kind-flask-mysql-lab
```

### 2. Build the Flask image and load it into the cluster

`kind` clusters don't have access to your local Docker images by default —
they run in their own isolated environment, so the image must be explicitly
loaded in:

```bash
docker build -t flask-mysql-demo:stage3 .
kind load docker-image flask-mysql-demo:stage3 --name flask-mysql-lab
```

### 3. Create the real Secret (never commit this file)

```bash
kubectl create secret generic flask-secret \
  --namespace=flask-mysql \
  --from-literal=DB_USER=root \
  --from-literal=DB_PASSWORD=changeme \
  --from-literal=MYSQL_ROOT_PASSWORD=changeme \
  --dry-run=client -o yaml > k8s/secret.yaml
```

(This command needs the namespace to exist first — apply `00-namespace.yaml`
before running it, or just create the namespace inline:
`kubectl create namespace flask-mysql` first.)

### 4. Apply all manifests, in order

```bash
kubectl apply -f k8s/00-namespace.yaml
kubectl apply -f k8s/01-configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/03-mysql-pvc.yaml
kubectl apply -f k8s/04-mysql-deployment.yaml
kubectl apply -f k8s/05-mysql-service.yaml
kubectl apply -f k8s/06-flask-deployment.yaml
kubectl apply -f k8s/07-flask-service.yaml
```

Or apply the whole folder at once (Kubernetes handles most ordering itself,
but doing it in numbered order the first time helps you see what depends on
what):

```bash
kubectl apply -f k8s/
```

### 5. Watch it come up

```bash
kubectl get pods -n flask-mysql -w
```

Wait until both `mysql-...` and both `flask-app-...` pods show `Running` and
`1/1 READY`. Ctrl+C to stop watching.

### 6. Access the app

Thanks to the `kind-config.yaml` port mapping, visit:

```
http://localhost:30080
```

### 7. Prove the self-healing behavior (the actual point of this stage)

Delete one of the Flask pods on purpose:

```bash
kubectl get pods -n flask-mysql
kubectl delete pod <one-of-the-flask-app-pod-names> -n flask-mysql
```

Then immediately:

```bash
kubectl get pods -n flask-mysql -w
```

You'll see Kubernetes automatically create a replacement pod within
seconds — this is the exact capability docker-compose didn't have, and the
reason this stage exists.

### 8. Clean up

```bash
kind delete cluster --name flask-mysql-lab
```

## Security Notes

- MySQL's Service is `ClusterIP` (internal-only) — never exposed outside
  the cluster.
- `k8s/secret.yaml` (the real one, with real values) is gitignored; only
  `02-secret.example.yaml` is committed.
- Resource `requests`/`limits` are set on both Deployments to prevent one
  pod from starving others on the same node.

## What's deliberately NOT here yet

- No Ingress (Stage 4)
- No Horizontal Pod Autoscaling (Stage 4)
- No CI/CD (Stage 5)
- No GitOps (Stage 6)

## Lessons Learned

- `kind` clusters don't share your local Docker image cache — forgetting
  `kind load docker-image` is the most common first-run failure, since the
  cluster will report `ImagePullBackOff` trying to pull a non-existent
  remote image instead of using the one you just built locally.
- MySQL was deliberately kept at `replicas: 1` — naively scaling a
  stateful database via `replicas: 2+` doesn't give you redundancy, it
  gives you data corruption, since both pods would attempt to write to
  the same PVC independently. Real MySQL high-availability needs proper
  replication, which is out of scope for this stage.
