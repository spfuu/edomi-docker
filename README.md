## edomi-docker (Edomi release: v1.44)
 
 This is a docker implementation for Edomi, a Smarthome framework.
 For more inforamtion please refer to:
 
 [Official website](http://www.edomi.de/)
 [Support forum](https://knx-user-forum.de/forum/projektforen/edomi)

 This instruction works for a <b>Centos7</b> docker host. Other distributions need some adjustments.


### 1. Install docker

```shell
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
```

```shell
sudo yum install docker-engine -y
```
```shell
sudo systemctl enable docker.service
```
```shell
sudo systemctl start docker.service
```

### 2. Build the Edomi Container

You now have two options: build from scratch or pull the ready-made image from Docker hub. 
The Image (and the Dockerfile) contains all packages needed by edomi. I've added openssh-server and additionally 
i've set the root password to '123456'.

#### 2a Image from Docker hub

```shell
sudo docker pull pfischi/edomi
```

#### 2b Built it from scratch

##### pull edomi-docker from github

```shell
sudo git clone https://github.com/pfischi/edomi-docker.git
cd edomi-docker
```

##### pull Centos 6.8 docker image and build it

```shell
sudo docker pull centos:6.8
sudo docker build -t pfischi/edomi:latest .
```

### 3. starting docker container

```shell
sudo docker run --name edomi -p 42900:80 -p 22222:22 -p 50000:50000/udp -p 50001:50001/udp -e KNXGATEWAY=192.168.178.4 -e KNXACTIVE=true -e HOSTIP=192.168.178.3 -d pfischi/edomi:latest
```

With this configuration the edomi web instance is reachable via http://<docker-host-ip>:42900/admin, the ssh server with 
ssh -p 22222 <docker-host-ip>. With The (optional) parameters KNXGATEWAY, KNXACTIVE and HOSTIP you can preconfigure some settings 
for edomi. Leave it empty to do this via the Edomi admin webpage. Keep in mind to set "global_serverIP" in Edomi (or via docker run script 'HOSTIP') 
to your Docker host IP otherwise the KNX communication probably will not work.


### 4. Autostart Edomi Docker container

```shell
sudo cp docker-edomi.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start docker-edomi.service
sudo systemctl enable docker-edomi.service
```

### 5. Useful commands

check running / stopped container

```shell
sudo docker ps -a
```

stop the container

```shell
sudo docker stop edomi
```

start the container

```shell
sudo docker start edomi
```

get logs from container

```shell
sudo docker logs -f edomi
```


