# TsiguroSD_microservices
TsiguroSD microservices repository

# HW docker-2

1) Installed docker with docker-tools
2) Ran containers with different options  

        docker run -it ubuntu:16.04 /bin/bash
        docker start u_container_id
        docker attach u_container_id
        docker exec -it <u_container_id> bash

3) Built images and reddit image

        docker commit 379fe7a660cc tsigurosd/ubuntu-tmp-file

4) Configured docker-machine with GCE in new project  
5) Added simple dockerfile to build image with reddit

        docker build -t reddit:latest .
6) Added reddit-imfge un docker hub

        docker tag reddit:latest <your-login>/otus-reddit:1.0
        docker push <your-login>/otus-reddit:1.0

## To-do list

Automate creating machines in GCE, installing docker and deploying of reddit app, using terraform, ansible and packer
