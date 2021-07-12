#!/bin/bash

CONTAINER=g4image
USER="geant4"

docker exec -it --user=$USER $CONTAINER bash
