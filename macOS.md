1. Install Docker Desktop (https://docs.docker.com/docker-for-mac/install/) or Docker Toolbox (https://docs.docker.com/toolbox/toolbox_install_mac/) if you have an older Mac
2. Test your docker installation:
    1. `$ docker --version`<br>
    should return something like <br>
    _Docker version 19.03.5, build 633a0ea_
    2. Try the “hello-world” Docker image <br>
    `$ docker run hello-world` <br>
    this should pull the image and return a message: <br>
    _Hello from Docker!_ <br>
    _This message shows that your installation appears to be working correctly._
3. Make sure you have XQuartz installed, you’ll need it to open X11 windows from the Docker image (https://www.xquartz.org)
4. Change XQuartz settings to allow remote connections to open X windows: <br>
    _XQuartz -> Preferences -> Security -> Allow connections from network clients_
5. Create a local folder for your GEANT4 work. This folder will be shared between your local system and the docker image, e.g. <br>
    `$ mkdir -p ~/docker/geant4` <br>
    `$ cd ~/docker/geant4`
6. To minimize the size of the Docker image the data files required by GEANT4 were not included, so you need to download them from the GEANT4 website and uncompress inside a ‘data’ directory in the shared folder: <br>
    `$ mkdir -p data` <br>
    Go to this webpage (http://geant4.web.cern.ch/support/download_archive?page=1) and download and uncompress all the “Data files” inside the folder you just created (you can delete the compressed versions afterwards). In case you’re wandering how to decompress .tar or .tar.gz files: <br>
    `$ tar xvzf theFile.tar.gz` <br>
    or <br>
    `$ tar xvf theFile.tar`
7. In the end you should have something like this: <br>
    `$ pwd` <br>
    _/Users/alex/docker/geant4_ <br>
    `$ ls data` <br>
    _G4ABLA3.1 <br>
    G4ENSDFSTATE2.2 <br>
    G4NEUTRONXS1.4 <br>
    G4SAIDDATA1.1 <br>
    RadioactiveDecay5.2 <br>
    G4EMLOW7.3 <br>
    G4NDL4.5 <br>
    G4PII1.3 <br>
    PhotonEvaporation5.2 <br>
    RealSurface2.1.1_ <br>
8. You can now get the Docker image containing GEANT4. Select one of the 2 available, depending on whether you want a more advanced (Qt) interface or not (the image with Qt requires 1.85 GB, while the other takes 1.45 GB): <br>
    `$ docker pull alexlindote/geant4-qt` <br>
    or <br>
    `$ docker pull alexlindote/geant4`
9. Before starting the docker container, find out your IP address and tell your computer to accept connections from it (sounds a bit like Inception, but this is needed to open the X11 windows) <br>
    `$ ifconfig`<br>
    (depending on whether you’re connected with an ethernet cable or using wireless your IP should be under en0 or en1, respectively, after inet) <br>
    `$ export IP=172.16.102.25` <br>
    `$ xhost + $IP`
10. We are now ready to start the docker container: <br>
    `$ docker run -it -d --name g4image -v /tmp/.X11-unix:/tmp/.X11-unix -v $PWD/:/usershared -e DISPLAY=$IP:0 alexlindote/geant4-qt` <br>
    or, if you’re using the image with no Qt interface, just remove the final ‘-qt’
11. You should now be able to see that the container is running with: <br>
    `$ docker ps`
12. Start a session inside the container with <br>
    `$ docker exec -it --user="geant4" g4image bash` <br>
    You can exit and rejoin whenever you want, and even have multiple sessions open. As long as the container is running, all the changes you make will remain in place between sessions.
13. Your local folder is shared under `/usershared`, so anything inside this folder is editable by your Mac and inside the image. This also means that changes inside this folder are permanent.
14. Let’s test GEANT4 using one of its examples, compile and run it: <br>
    1. `$ cp -r /usr/local/geant4/geant4.10.04.p03-install/share/Geant4-10.4.3/examples/basic/B2/B2a /usershared/`
    2. `$ cd /usershared/B2a`
    3. `$ make`
    4. `$ exampleB2a`
    5. In the Qt window that opens, type `/run/beamOn 1` in the “Session” box at the bottom and press enter. You should see particle trajectories. Use the mouse to rotate, zoom in and out.
    6. If you don’t see the Qt window, you may need to downgrade your XQuartz to v2.7.8 <br>
    (probably you’re using Docker Toolbox in an older system)
15. That’s it! You are ready to run GEANT4 in your computer!