# edomi-docker

 This instruction works under docker host <br>CentOS 7</b>. Other distributions need some adjustments.

### 1. install docker

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
git clone https://github.com/pfischi/edomi-docker.git
cd edomi-docker
```

##### pull Centos 6.8 docker image and build it

```shell
sudo docker pull centos:6.8
sudo docker build -t edomi .
```

```

### 3. Initialize the Edomi Docker container

 **Edit bin/start.sh and change "SERVERIP" to the IP of your DOCKER HOST (not the docker container IP).** Otherwise
 the communication to you knx router/interface might not work. You have to edit these file in your container under
 /root/start.sh if your docker host ip has changed. Please be aware that the variable 'global_serverIP' in the edomi.ini
 will be overwritten after a restart with the configured HOSTIP variable in start.sh.


### starting docker container

```shell
sudo docker run --name edomi -p 42900:80 -p 22222:22 -p 50000:50000/udp -p 50001:50001/udp -d edomi
```

With this configuration the edomi web instance is reachable via http://<docker-host-ip>:42900/admin, the ssh server with 
ssh -p 22222 <docker-host-ip>. Change this to your needs.


### autostart edomi docker conatiner

```shell
sudo cp docker-edomi.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start docker-edomi.service
sudo systemctl enable docker-edomi.service
```

### useful commands

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
docker logs -f edomi
```


