#!/bin/bash
# code from https://github.com/RUB-SysSec/GANDCTAnalysis/blob/master/docker.sh
# Copyright (c) 2021 Chair for Sys­tems Se­cu­ri­ty, Ruhr University Bochum

# usage ----------------------------------------------
# bash docker.sh build  # build image
# bash docker.sh shell  # run container
# ----------------------------------------------------

DATASET_DIRS="/drive/dataset"
DATA_DIRS="/drive/data"

build()
{
    docker build . -f docker/Dockerfile --build-arg USER_UID=`(id -u)` --build-arg USER_GID=`(id -g)` -t tf63/cu11.1.1-torch1.8.1
}

run()
{
    # https://docs.docker.jp/engine/reference/commandline/run.html
    docker run --rm --name cil --gpus all --shm-size=32g -it --env-file ./.env -v $(pwd):/app -v $DATASET_DIRS:/dataset -v $DATA_DIRS:/data tf63/cu11.1.1-torch1.8.1
}

start()
{
    # https://docs.docker.jp/engine/reference/commandline/start.html
    docker start -i diffuser
}

if [[ $1 == "build" ]]; then
    build
elif [[ $1 == "run" ]]; then
    run
elif [[ $1 == "start" ]]; then
    start
else
    echo "error: invalid argument"
fi
