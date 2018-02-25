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


