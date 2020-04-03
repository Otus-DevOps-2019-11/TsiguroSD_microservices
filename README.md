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

# HW docker-3

1) Добавили докер образы для контейнеров с микросервисами: post, comment, ui

2) Пересоздали контейнеры, указав другие алиасы и переменные окружения


        2386  docker run -d --network=reddit --network-alias=post_db2 --network-alias=comment_db2 mongo:latest\n
        2387  docker run -d --network=reddit --network-alias=comment2 --env COMMENT_DATABASE_HOST=comment_db2 --env COMMENT_DATABASE=comments tsigurosd/comment:1.0
        2388  docker run -d --network=reddit --network-alias=post2 --env POST_DATABASE_HOST=post_db2 --env POST_DATABASE=posts tsigurosd/post:1.0\n
        2389  docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=post2 --env POST_SERVICE_PORT=5000 --env COMMENT_SERVICE_HOST=comment2 --en COMMENT_SERVICE_PORT=9292 tsigurosd/ui:1.0

3) Сократили размер образа для ui, используя другие базовые образы

        tsigurosd/ui            4.0                 e2658fe8e3af        12 minutes ago      167MB
        tsigurosd/ui            3.0                     c7141e02b1d7        16 minutes ago      435MB
        tsigurosd/ui            2.0                     6d334b2a2b59        21 minutes ago      461MB
        tsigurosd/ui            1.0                     2694108c5f5d        About an hour ago   774MB

4) Подключили volume к контейнеру с БД, првоерили что теперь посты сохраняются при перезапуске контейнера  

        docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
