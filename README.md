# Guidelines for working with Ansible-Container & docker-machine flow of development

# First take care of the *project skelton*
```
ansible-container init 
ansible-container build
```
# Add a Galaxy role if needed
```
ansible-container install ansible.nginx-container
```

## The added Galaxy role files

- requirements.yml
```
src: ansible.nginx-container
```

## Added to container.yml automatically too

- container.yml:
```
services:
  ansible.nginx-container:
    roles:
    - ansible.nginx-container
```

## Build & Run
```
ansible-container build
ansible-container run
```

(Adding varaiables to container.yml for overriding vars)
https://github.com/ansible/nginx-container

## PUSH
```
ansible-container push  --username levmichael3 --password *** --push-to docker.io/levmichael3 --tag 1.0

Parsing conductor CLI args.
Engine integration loaded. Preparing push.      engine=Docker™ daemon
Tagging docker.io/levmichael3/webstack_demo-webserver
Pushing docker.io/levmichael3/webstack_demo-webserver:1.0...
The push refers to repository [docker.io/levmichael3/webstack_demo-webserver]
Preparing
Layer already exists
1.0: digest: sha256:c84ae60e737e87274b566950f6437011a8cf12b4f8eb909d0a4f4b55b2d758b2 size: 741
Conductor terminated. Cleaning up.      command_rc=0 conductor_id=ac99b957a86a912019f3f59fcc1fc4bc612b4bc0d14916679f5ea55c15767133 save_container=False
```

## Pull from docker-machine aws-sandbox

# start the docker-machine
```
docker-machine start aws-sandbox
docker-machine regenerate-certs -f aws-sandbox
eval "$(docker-machine env aws-sandbox)"
docker-machine status aws-sandbox
```

# pull the pushed images from local dev box to docker.hub into the docker-machine
```
docker login
docker -D pull levmichael3/webstack_demo-webserver
```

# Run it (on docker-machine with ENVs loaded properly to work infron of the aws-sandbox)
```
docker run -d -p 80:8000 --name webserver levmichael3/webstack_demo-webserver:latest
```

# Use variable files with --var-files <file.yml>

```
ansible-container --vars-files variable_files/dogs.yml build --no-container-cache
ansible-container --vars-file  /root/Development/ansible-docker/mariadb/variable_files/dogs.yml run
```

- Then `docker ps` shows dynamic port:
```
docker ps
CONTAINER ID        IMAGE                                      COMMAND                  CREATED             STATUS              PORTS                    NAMES
b6f5059f8077        mariadb-mariadb_container:20180226125105   "/usr/bin/dumb-init â€¦"   7 seconds ago       Up 6 seconds        0.0.0.0:3308->3306/tcp   mariadb_mariadb_container_1
```

# Updated gcloud credentials and Enabled access using the token stored in the auth section

Use `deploy` to deploy:

```
ansible-container --engine k8s deploy --username levmichael3 --password ***** --push-to docker  --tag kubernetes  


Parsing conductor CLI args.
Engine integration loaded. Preparing push.      engine=K8s
Tagging index.docker.io/levmichael3/mariadb-k8s-mariadb-container
Pushing index.docker.io/levmichael3/mariadb-k8s-mariadb-container:kubernetes...
The push refers to repository [docker.io/levmichael3/mariadb-k8s-mariadb-container]
Preparing
Waiting
Pushing
Mounted from levmichael3/mariadb-mariadb_container
Pushing
Mounted from levmichael3/mariadb-mariadb_container
Pushing
Mounted from levmichael3/mariadb-mariadb_container
Pushing
Mounted from levmichael3/mariadb-mariadb_container
Pushing
Mounted from levmichael3/mariadb-mariadb_container
Pushing
Pushed
kubernetes: digest: sha256:246931101f7a16e1fe39d5c532baff17c1c6ecc0d074603edf4a0073e4cbea3f size: 1569
Conductor terminated. Cleaning up.      command_rc=0 conductor_id=2e0b9cf6c70e591c32e0d86f5250e352caefcc84040ac7ffdb374aa00e01abb8 save_container=False
Parsing conductor CLI args.
Engine integration loaded. Preparing deploy.    engine=K8s
Verifying image for mariadb-container
ansible-galaxy 2.5.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python2.7/dist-packages/ansible
  executable location = /usr/local/bin/ansible-galaxy
  python version = 2.7.12 (default, Nov 19 2016, 06:48:10) [GCC 5.4.0 20160609]
Using /etc/ansible/ansible.cfg as config file
Opened /root/.ansible_galaxy
Processing role ansible.kubernetes-modules
Opened /root/.ansible_galaxy
- downloading role 'kubernetes-modules', owned by ansible
https://galaxy.ansible.com/api/v1/roles/?owner__username=ansible&name=kubernetes-modules
https://galaxy.ansible.com/api/v1/roles/16501/versions/?page_size=50
- downloading role from https://github.com/ansible/ansible-kubernetes-modules/archive/v0.3.1-6.tar.gz
- extracting ansible.kubernetes-modules to /root/Development/ansible-docker/mariadb/ansible-deployment/roles/ansible.kubernetes-modules
- ansible.kubernetes-modules (v0.3.1-6) was installed successfully
Conductor terminated. Cleaning up.      command_rc=0 conductor_id=74ac339825a5c4278098a9931dc55a397c7123f433018d35ff3646579a9fc5ab save_container=False

```
