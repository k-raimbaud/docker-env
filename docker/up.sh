#!/usr/bin/env bash

todo=${1-up}

if [ $todo = "build" ]; then

    file='docker.env'
    gitName="$(git config --global user.name)"
    gitEmail="$(git config --global user.email)"

    if [ -a $file ];
    then
       echo "$file file exists."
    else
       echo "$file file does not exist."
       touch $file
       echo "gitEmail=\"$gitEmail\"" >> $file
       echo "gitName=\"$gitName\"" >> $file
       echo "$file file has been created"
    fi

    docker-compose build
    docker stop $(docker ps -a -q)
    docker rm php-fpm
    docker rm php-apache
    docker rm phpmyadmin
    docker rm mysql
    docker rm nginx

    echo 'BUILDED';

elif [ $todo = "up" ]; then
    echo 'UP';
else
    echo 'Parameter not found'
    exit
fi

docker-compose up -d
docker exec -ti php-fpm zsh