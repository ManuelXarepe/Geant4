#!/bin/bash

EXTRA=""

# uncomment there lines ONLY if you have problems with the docker image
# uncomment the following 2 lines in sequence if your X display is not working,
# i.e. try uncommenting only the first one before trying to uncomment both
#EXTRA="--net=host"
#chmod a+rw ~/.Xauthority
# uncomment the following line if you cannot write to the shared folder inside the container 
#chmod -R a+rw .

IMAGE=alexlindote/geant4-qt
CONTAINER=g4image

echo "Don't worry if you see error messages between this point..."
# stop running container
docker stop $CONTAINER
docker rm $CONTAINER
echo "... and this point. Further errors are more worrying!"

#do some OSX setup for xforwarding
OS="$(uname -s)"
if [ ${OS} = "Darwin" ]; then
    xhost + 127.0.0.1 # X11 forwarding to host
else 
# don't run this for macOS, crazy weird results
# env parameters
HOST_PASSWD_ENTRY=$(cat /etc/passwd | grep "^${USER}")
HOST_UID=$(echo ${HOST_PASSWD_ENTRY} | cut -f3 -d:)
HOST_GID=$(echo ${HOST_PASSWD_ENTRY} | cut -f4 -d:)
ENV_DIR=${PWD}/env/
mkdir -p ${ENV_DIR}
cat > ${ENV_DIR}/user_hosted.env << EOF
HOST_UID=${HOST_UID}
HOST_GID=${HOST_GID}
EOF

fi

docker run -i -d -t --name $CONTAINER \
    --env-file ${ENV_DIR}/user_hosted.env \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOME/.Xauthority:/home/geant4/.Xauthority" \
    -v $PWD:/usershared \
    $EXTRA -e DISPLAY=$DISPLAY \
    alexlindote/geant4-qt
