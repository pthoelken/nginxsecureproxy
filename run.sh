#!/bin/bash

cd "$(dirname "$0")"

strDockerHubUsername=pthoelken
strDockerImageName=nginxsecureproxy
strDockerImageTag=latest

strDebugFolder=./debugging

strDebugDockerComposeFile=$strDebugFolder/docker-compose.yml
strDockerComposeURL=https://raw.githubusercontent.com/pthoelken/nginxsecureproxy/main/docker-compose.yml

strGitHubRepositoryURL=git@github.com:pthoelken/nginxsecureproxy.git

function BuildImage() {
    docker builder prune -a -f 
    docker build -t $strDockerImageName .
    docker image tag $strDockerImageName $strDockerHubUsername/$strDockerImageName:$strDockerImageTag
}

function PublishImage() {
    docker login -u $strDockerHubUsername
    docker image push $strDockerHubUsername/$strDockerImageName:$strDockerImageTag
}

function DebugImage() {

    if [ ! -f $strDebugFolder ]; then
        rm -rf $strDebugFolder
        mkdir -p $strDebugFolder
    fi

    cd $strDebugFolder

    if [ -f $strDebugFolder/.git ]; then
        git pull
    else
        git clone $strGitHubRepositoryURL .
    fi

    docker-compose down
    docker image prune -a -f
    docker container prune -f

    Build
    Publish
    
    curl -Lo $strDebugDockerComposeFile $strDockerComposeURL
    docker-compose up -d
}

case "$1" in
        "--build")
        BuildImage
        ;;
        "--debug")
        DebugImage
        ;;
        "--publish")
        BuildImage
        PublishImage
        ;;
        *)
        echo "Unknown argument for $0 please use { --build | --debug | --publish }"
        exit 1
        ;;
esac