# Geant4

1. Install Docker for your particular system. You can probably find tutorials online, e.g.
    - ubuntu 16.04 - 20.04: [https://docs.docker.com/engine/install/ubuntu/#](https://docs.docker.com/engine/install/ubuntu/#)
    - instructions for other flavours will be added, if you have tested instructions please let us know
2. Test your docker installation:
    1. `$ docker --version`
    should return something like *Docker version 19.03.5, build 633a0ea*
    2. Try the “hello-world” Docker image `$ docker run hello-world` 
    this should pull the image and return a message: *Hello from Docker!* *This message shows that your installation appears to be working correctly.*
    3. If you have problems running docker and need to run it as *sudo*, then you need to add your user to the docker group. Run:`$ sudo usermod -aG docker <USER>` 
    where is your username. Then you need to reboot your computer. When you log back in, if you type `groups` you should see docker in the list displayed.
3. Create a local folder for your GEANT4 work. This folder will be shared between your local system and the docker image, e.g. `$ mkdir -p ~/docker/geant4` `$ cd ~/docker/geant4`
4. To minimize the size of the Docker image the data files required by GEANT4 were not included, so you need to download them from the GEANT4 website and uncompress inside a ‘data’ directory in the shared folder: `$ mkdir -p data` 
Go to this webpage ([http://geant4.web.cern.ch/support/download_archive?page=1](http://geant4.web.cern.ch/support/download_archive?page=1)) and download and uncompress all the “Data files” inside the folder you just created (you can delete the compressed versions afterwards). In case you’re wandering how to decompress .tar or .tar.gz files: `$ tar xvzf theFile.tar.gz` 
or `$ tar xvf theFile.tar`
5. In the end you should have something like this: `$ pwd` ~/*docker/geant4* `$ ls data` *G4ABLA3.1 
G4ENSDFSTATE2.2 
G4NEUTRONXS1.4 
G4SAIDDATA1.1 
RadioactiveDecay5.2 
G4EMLOW7.3 
G4NDL4.5 
G4PII1.3 
PhotonEvaporation5.2 
RealSurface2.1.1*
6. You can now get the Docker image containing GEANT4: `$ docker pull alexlindote/geant4-qt`
7. We are now ready to start the docker container. Download the two scripts in this folder (`setup_docker.sh` and `run_docker.sh`) to your `geant4` folder. Start the container by running: `$ source setup_docker.sh` 
Note that by default this script will use the Qt image, if you want to use the smaller one you'll need to edit the script before executing the above command removing ‘-qt’ references.
8. You should now be able to see that the container is running with: `$ docker ps`
9. Start a session inside the container using the other script `$ source run_docker.sh` 
You can exit and rejoin whenever you want, and even have multiple sessions open. As long as the container is running, all the changes you make will remain in place between sessions.
10. Your local folder is shared under `/usershared`, so anything inside this folder is editable by your native system and inside the image. This also means that changes inside this folder are permanent.
11. Let’s test GEANT4 using one of its examples, compile and run it:
    1. `$ cp -r /usr/local/geant4/geant4.10.04.p03-install/share/Geant4-10.4.3/examples /usershared/`
    2. `$ cd /usershared/examples/basic/B2/B2a`
    3. `$ mkdir build`
    4. `$ cd build`
    5. `$ cmake ..`
    6. `$ make`
    7. `$ ./exampleB2a`
    8. In the Qt window that opens, type `/run/beamOn 1` in the “Session” box at the bottom and press enter. You should see particle trajectories. Use the mouse to rotate, zoom in and out.
    If you see an error about writing permissions when trying step 1. above, exit the container and edit the setup script to uncomment the line `#chmod -R a+rw .` -- then source the setup script again.
12. That’s it! You are ready to run GEANT4 in your computer!
