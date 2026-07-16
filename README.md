I was using Docker Desktop for Docker and Docker-Compose. 

I used Kind in Docker Desktop but did not work. 

I used Killerkoda but port issue came. 

Now I am using Docker Desktop for virtualization and Minikube for Kubernetes. 



in MYSQL, we have:

host

user 

password

root password

db name 

if we are using docker mysql then host is docker mysql container name 

if we are suing k8s, then host is mysql service name 

cp .env.example .env 


 sudo apt install docker-compose

docker-compose up


if we are uisng killerkoda, we have only 2 ports then change docker-compose file:



in MYSQL, we have:
host
user 
password
root password
db name 

if we are using docker mysql then host is docker mysql container name 

if we are suing k8s, then host is mysql service name 

---

cp .env.example .env 


docker-compose up


if we are uisng killerkoda, we have only 2 ports then change docker-compose file:

docker --version

minikube start --driver=docker

minikube status 

docker-compose up  

localhost5000

enter data 

docker-compose up  

docker images 

You are seeing docker image of flaks app PLEASE ADD IN FLASK-DEPLOYEMENT FILE flask-mysql:latest 



add image in flask-deployemtn file 

Note: one tihngs for important: 

when we did docker and docker-comspsoe: our host was mysql container name 

when we are doing k8s, our host is mysql service name 

kubectl apply -f k8s/

minikube image load flask-mysql:latest

BECASUE THE IMAGE IS IN LOCAL laptop 

