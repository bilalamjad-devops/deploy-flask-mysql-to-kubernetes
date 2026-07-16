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
