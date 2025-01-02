# Guidelines for working with Ansible-Container & docker-machine flow of development

<a href="https://github.com/devxb/gitanimals">
  <img src="https://render.gitanimals.org/lines/levmichael3" width="1000" height="120"/>
</a>

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
#ansible-container push  --username levmichael3 --password *** --push-to docker.io/levmichael3 --tag 1.0

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

# Run it 

(on docker-machine with ENVs loaded properly to work infron of the aws-sandbox)
```
docker run -d -p 80:8000 --name webserver levmichael3/webstack_demo-webserver:latest
```

# Use variable files 

with --var-files <file.yml>

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

# In order to use K8S or openshift update the config_file 
showing on http://docs.ansible.com/ansible-container/container_yml/reference.html#k8s-auth - use ` gcloud auth application-default login`

* in container.yml : Project name MUST match :
```
k8s_namespace:
    name: ansible-container-sandbox <<<<
```
# Deploy to K8S/Openshift

Use `deploy` to deploy:

```
#ansible-container --engine k8s deploy --username levmichael3 --password ***** --push-to docker  --tag kubernetes  


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


# Example

From https://github.com/ansible/ansible-container-demo 



- push the images to docker hub:

```
# ansible-container push  --username levmichael3 --password ****** --push-to docker.io/levmichael3 --tag openshift
Parsing conductor CLI args.
Engine integration loaded. Preparing push.      engine=Dockerâ„¢ daemon
Tagging docker.io/levmichael3/django-gulp-nginx-django
Pushing docker.io/levmichael3/django-gulp-nginx-django:openshift...
The push refers to repository [docker.io/levmichael3/django-gulp-nginx-django]
Preparing
Pushing
Pushed
Pushing
Pushed
openshift: digest: sha256:a5713004e511e6b76c0bd6b2f7c37d42d021e1227af88fb489a7df7830cc7011 size: 742
Tagging docker.io/levmichael3/django-gulp-nginx-gulp
Pushing docker.io/levmichael3/django-gulp-nginx-gulp:openshift...
The push refers to repository [docker.io/levmichael3/django-gulp-nginx-gulp]
Preparing
Pushing
Mounted from levmichael3/django-gulp-nginx-django
Pushing
Pushed
openshift: digest: sha256:4ad54c25da4e398b4c419e5c2a682cf2c8208eb6aa604a1b869066602065dee8 size: 742
Tagging docker.io/levmichael3/django-gulp-nginx-nginx
Pushing docker.io/levmichael3/django-gulp-nginx-nginx:openshift...
The push refers to repository [docker.io/levmichael3/django-gulp-nginx-nginx]
Preparing
Pushing
Mounted from levmichael3/django-gulp-nginx-gulp
Pushing
Pushed
openshift: digest: sha256:f248bf4c2cde54773872058b1e2a32043732a5168e18b89216ccbb2572350f6e size: 741
Conductor terminated. Cleaning up.      command_rc=0 conductor_id=9f51f494f195550b390f31345a8e0cb00949629a2274803cc268fb98701a0b62 save_container=False
```

- images are there:

```
#docker images levmichael3/*:openshift
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE
levmichael3/django-gulp-nginx-nginx    openshift           897b6b11fd22        About an hour ago   286MB
levmichael3/django-gulp-nginx-gulp     openshift           d19da14ec3db        About an hour ago   734MB
levmichael3/django-gulp-nginx-django   openshift           3d0022cff6ce        About an hour ago   1.01GB
```


- Create the deployment menifests:

```

#ansible-container --engine openshift deploy  --username levmichael3 --password ***** --push-to docker  --tag openshift
Parsing conductor CLI args.
Engine integration loaded. Preparing push.      engine=OpenShiftâ„¢
Tagging index.docker.io/levmichael3/django-gulp-nginx-django
Pushing index.docker.io/levmichael3/django-gulp-nginx-django:openshift...
The push refers to repository [docker.io/levmichael3/django-gulp-nginx-django]
Preparing
Layer already exists
openshift: digest: sha256:9b1755acfd0aeadb18883bf2d9276c0615b4b6c85f406d7d6776cd28a9c17c07 size: 742
Tagging index.docker.io/levmichael3/django-gulp-nginx-gulp
Pushing index.docker.io/levmichael3/django-gulp-nginx-gulp:openshift...
The push refers to repository [docker.io/levmichael3/django-gulp-nginx-gulp]
Preparing
Layer already exists
openshift: digest: sha256:8bff25a2822620eff1aee30f0300ec42201785e8b058bbc319c9f6b826b5a229 size: 742
Tagging index.docker.io/levmichael3/django-gulp-nginx-nginx
Pushing index.docker.io/levmichael3/django-gulp-nginx-nginx:openshift...
The push refers to repository [docker.io/levmichael3/django-gulp-nginx-nginx]
Preparing
Layer already exists
openshift: digest: sha256:f0540c2497ef8ed8c66cce610ef3ab20ba85da5f6646d256806c255488879b88 size: 741
Conductor terminated. Cleaning up.      command_rc=0 conductor_id=45fb5726576e8ae2a0ec7961126f95b2e4535bead045179d306cb267899f3d16 save_container=False
Parsing conductor CLI args.
Engine integration loaded. Preparing deploy.    engine=OpenShiftâ„¢
Verifying image for django
Verifying image for gulp
Verifying image for nginx
ansible-galaxy 2.5.0
  config file = None
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible-galaxy
  python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)]
No config file found; using defaults
Opened /root/.ansible_galaxy
Processing role ansible.kubernetes-modules
Opened /root/.ansible_galaxy
- downloading role 'kubernetes-modules', owned by ansible
https://galaxy.ansible.com/api/v1/roles/?owner__username=ansible&name=kubernetes-modules
https://galaxy.ansible.com/api/v1/roles/16501/versions/?page_size=50
- downloading role from https://github.com/ansible/ansible-kubernetes-modules/archive/v0.3.1-6.tar.gz
- extracting ansible.kubernetes-modules to /root/Development/ansible-docker/django-gulp-nginx/ansible-deployment/roles/ansible.kubernetes-modules
- ansible.kubernetes-modules (v0.3.1-6) was installed successfully
Conductor terminated. Cleaning up.      command_rc=0 conductor_id=d41c87c68192fe50ab934c33fdab27d2f7d5d8218c7e755fb8030ad20e1f9bd1 save_container=False

```


- run in OpenShift:


```
# ansible-container  --engine openshift   run
Parsing conductor CLI args.
Engine integration loaded. Preparing run.       engine=OpenShiftâ„¢
Verifying service image service=django
Verifying service image service=gulp
Verifying service image service=nginx

PLAY [Manage the lifecycle of django-gulp-nginx on OpenShift?] *****************

TASK [Create project ansible-container-sandbox] ********************************
  : [localhost]
â–½
TASK [Create service] **********************************************************
changed: [localhost]

TASK [Create service] **********************************************************
changed: [localhost]

TASK [Remove service] **********************************************************
ok: [localhost]

TASK [Create deployment, and scale replicas up] ********************************
changed: [localhost]

TASK [Create deployment, and scale replicas up] ********************************
changed: [localhost]

TASK [Create deployment, and scale replicas up] ********************************
changed: [localhost]

TASK [Remove deployment] *******************************************************
ok: [localhost]

TASK [Remove route] ************************************************************
ok: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=5    unreachable=0    failed=0

All services running.   playbook_rc=0
Conductor terminated. Cleaning up.      command_rc=0 conductor_id=5cad77885ec05dfeb2830b05cdc584b5513b097da405cc3bf11e2a7839678552 save_container=False
```
