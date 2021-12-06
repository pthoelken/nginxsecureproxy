#!/bin/sh

set -e
cd "$(dirname "$0")"

strDockerHubUsername=pthoelken
strDockerImageName=nginxsecureproxy
strDockerImageTag=latest

strDebugFolder=./debug

strDebugDockerComposeFile=$strDebugFolder/docker-compose.yml
strDockerComposeURL=https://raw.githubusercontent.com/pthoelken/nginxsecureproxy/main/docker-compose.yml

function Build() {
    docker build -t $strDockerImageName .
    docker image tag $strDockerImageName $strDockerHubUsername/$strDockerImageName:$strDockerImageTag
}

function Publish() {
    docker login -u $strDockerHubUsername
    docker image push $strDockerHubUsername/$strDockerImageName:$strDockerImageTag
}

function Debug() {

    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker image prune -a -f
    docker container prune -f

    Build
    Publish

    if [ ! -f $strDebugFolder ]; then
        rm -rf $strDebugFolder
        mkdir -p $strDebugFolder
    fi

    cd $strDebugFolder
    curl -Lo $strDebugDockerComposeFile $strDockerComposeURL
    docker-compose up -d
}

case "$1" in
        "--build" )
        Build
        ;;
        "--debug" )
        Debug
        ;;
        "--publish" )
        Build
        Publish
        ;;
        *)
        echo "Unknown argument for $0 please use {--build | --debug | --publish}"
        exit 1
        ;;
esac