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

# HW docker-4

1) Провели эксперименты по созданию контйнеров с помощью разных провайдеров  
  - докер не создает контейнеры, которые связаны с одним портом хоста (провайдер хост)
  - при создание контейнеры с сетью хоста, неймспейса длё него не создается
2) Создали две различные подсети с помощью сетевых мостов для форнтенда и бэкенда, контейнеры с сервисами пост и коммент поместили в обе сети, присвоили сестевые алиасы для связи между контейнерами
3) Добавили *docker-compose.yml* для описания нашей инфраструктуры, параметризовали имя пользователя докерхаба, порты приложения и хоста, версии сервисов
5) Добавили файл .env с переменными окружения, которые подставляются в docker-compose при создании инфраструктуры
6) Базовое имя проекта соответсвует имени директории, в которой запускается docker-compose. С помощью переменной окружения COMPOSE_PROJECT_NAME задали имя проекта, теперь создаваемые контейнеры имеют имена типа *reddit_app_comment_1*
7) (*) Добавили конфигурацию docker-compose.override.yml, который позволяет изменять код приложений, не пересоздававая образы, и запускает руби приложения в дебаг режиме с двумя воркерами (флаги --debug и -w 2).

# HW gitlab-ci

1) Развернута ВМ с gitlab-ci omnibus с помощью terraform и ansible
2) Создан проект homework, добавлен репозиторий, добавлен runner для проекта
3) Написан pipeline для нескольких окржуений, с запуском теста и имитацией деплоя приложения на окружение
4) (*) Добавлен билд docker контйнера с приложением с помощью docker in docker (dind)

## To-do list
- Деплойте контейнер с reddit на созданный для
ветки сервер (?)
- Продумайте автоматизацию развертывания и регистрации
Gitlab CI Runner. В больших организациях количество Runners
может превышать 50 и более, сетапить их руками становится
проблематично.
Реализацию функционала добавьте в репозиторий в папку
gitlab-ci;
- Настройте интеграцию вашего Pipeline с тестовым Slack-чатом,
который вы использовали ранее. Для этого перейдите в Project
Settings > Integrations > Slack notifications. Нужно установить
active, выбрать события и заполнить поля с URL вашего Slack
webhook.
Добавьте ссылку на канал в слаке, в котором можно проверить
работу оповещений, в файл README.md;

# HW monitoring-1

1) Prometheus запущен в контейнере на докер-хосте
2) Добавлена конфигурация Prometheus на сбор метрик с микросервисов
3) Добавлен сбор метрик докер-хоста с использованием node exporter, также запущеного в контейнере
4) Последнии версии образов запушены на докер хаб
 - https://hub.docker.com/repository/docker/tsigurosd/post
 - https://hub.docker.com/repository/docker/tsigurosd/ui
 - https://hub.docker.com/repository/docker/tsigurosd/comment
 - https://hub.docker.com/repository/docker/tsigurosd/prometheus

# HW monitoring-2

1) Добавлен мониторинг контейнеров с помощью cAdvisor, развернутого так же в контейнере
2) Развернута  Grafana в контейнере
3) Добавлены дашборды Business_Logic_Monitoring, DockerMonitoring, UI_service_monitoring для мониторинга бизнес-логики приложения (количество постов и комментов), состояния и потребления ресурсов контейнеров, мониторинга самого приложения (количество http запросов и ошибок)
4) Добавлен алерт на отключение любого из сервисов с помощью AlertManager, настроены оповещения в канал Slack
