1. Check if your system meets the requirements for Docker Desktop (https://docs.docker.com/docker-for-windows/install/) and install it. Alternatively, install Docker Toolbox (https://docs.docker.com/toolbox/toolbox_install_windows/)
2. Windows does not support X windows natively, so you’ll need to install an X server. There are several options, here we use XMing (http://www.straightrunning.com/XmingNotes/ — the PublicDomain release should still work on recent systems)
    1. Run XLaunch (on the same folder as XMing, allows you to change the default behaviour of XMing)
    2. Move forward until you find box labelled “'No Access Control”, make sure to check it
    3. Save the new configuration in a file (preferably in your desktop, as you can later double click this file to start XMing with the right configuration)
    4. Start XMing by double clicking on the configuration file name (make sure to close XMing if it’s already running)
3. Start the Docker Console or a Windows PowerShell and test your docker installation:
    1. `$ docker --version`<br>
    should return something like <br>
    _Docker version 19.03.5, build 633a0ea_
    2. Try the “hello-world” Docker image <br>
    `$ docker run hello-world` <br>
    this should pull the image and return a message: <br>
    _Hello from Docker!_ <br>
    _This message shows that your installation appears to be working correctly._
4. Create a local folder for your GEANT4 work. This folder will be shared between your local system and the docker image, e.g. <br>
    cd to wherever you want to create the shared folder <br>
    `$ mkdir -p docker/geant4` <br>
    `$ cd docker/geant4`
6. To share this folder, we need to tweak the docker settings, adding your drive as shareable. For this, right click on the docker icon that should be in the drawer in your Windows task bar and select "Setting". Then go to "Shared Drives" and add your drive (typically C, if you created the shared folder in your personal area). Check out this link for a more visual guide: https://token2shell.com/howto/docker/sharing-windows-folders-with-containers/.
7. To minimize the size of the Docker image the data files required by GEANT4 were not included, so you need to download them from the GEANT4 website and uncompress inside a ‘data’ directory in the shared folder: <br>
    `$ mkdir -p data` <br>
    Go to this webpage (http://geant4.web.cern.ch/support/download_archive?page=1) and download and uncompress all the “Data files” inside the folder you just created (you can delete the compressed versions afterwards). It's probably easier if you use graphical tools for this step.
8. In the end you should have something like this: <br>
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
9. You can now get the Docker image containing GEANT4. Select one of the 2 available, depending on whether you want a more advanced (Qt) interface or not (the image with Qt requires 1.85 GB, while the other takes 1.45 GB): <br>
    `$ docker pull alexlindote/geant4-qt` <br>
    or <br>
    `$ docker pull alexlindote/geant4`
10. Before starting the docker container, find out your IP address <br>
    `$ ipconfig`<br>
11. We are now ready to start the docker container. Make sure you are inside your shared folder: <br>
    `$ docker run -it -d --name g4image -v ${PWD}:/usershared -e DISPLAY=<Your IP here>:0 alexlindote/geant4-qt` <br>
    or, if you’re using the image with no Qt interface, just remove the final ‘-qt’
12. You should now be able to see that the container is running with: <br>
    `$ docker ps`
13. Start a session inside the container with <br>
    `$ docker exec -it --user="geant4" g4image bash` <br>
    You can exit and rejoin whenever you want, and even have multiple sessions open. As long as the container is running, all the changes you make will remain in place between sessions.
14. Your local folder is shared under `/usershared`, so anything inside this folder is editable by your Mac and inside the image. This also means that changes inside this folder are permanent.
15. Let’s test GEANT4 using one of its examples, compile and run it: <br>
    1. `$ cp -r /usr/local/geant4/geant4.10.04.p03-install/share/Geant4-10.4.3/examples/basic/B2/B2a /usershared/`
    2. `$ cd /usershared/B2a`
    3. `$ make`
    4. `$ exampleB2a`
    5. In the Qt window that opens, type `/run/beamOn 1` in the “Session” box at the bottom and press enter. You should see particle trajectories. Use the mouse to rotate, zoom in and out.
16. That’s it! You are ready to run GEANT4 in your computer!