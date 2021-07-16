Check if your system meets the requirements for Docker Desktop (https://docs.docker.com/docker-for-windows/install/) and install it. Alternatively, install Docker Toolbox (https://docs.docker.com/toolbox/toolbox_install_windows/)
Windows does not support X windows natively, so you’ll need to install an X server. There are several options, here we use XMing (http://www.straightrunning.com/XmingNotes/ — the PublicDomain release should still work on recent systems)

Run XLaunch (on the same folder as XMing, allows you to change the default behaviour of XMing)
Move forward until you find box labelled “'No Access Control”, make sure to check it
Save the new configuration in a file (preferably in your desktop, as you can later double click this file to start XMing with the right configuration)
Start XMing by double clicking on the configuration file name (make sure to close XMing if it’s already running)


Start the Docker Console or a Windows PowerShell and test your docker installation:


$ docker --version
should return something like 
Docker version 19.03.5, build 633a0ea

Try the “hello-world” Docker image 
$ docker run hello-world 
this should pull the image and return a message: 
Hello from Docker! 
This message shows that your installation appears to be working correctly.



Create a local folder for your GEANT4 work. This folder will be shared between your local system and the docker image, e.g. 
cd to wherever you want to create the shared folder 
$ mkdir -p docker/geant4 
$ cd docker/geant4

To share this folder, we need to tweak the docker settings, adding your drive as shareable. For this, right click on the docker icon that should be in the drawer in your Windows task bar and select "Setting". Then go to "Shared Drives" and add your drive (typically C, if you created the shared folder in your personal area). Check out this link for a more visual guide: https://token2shell.com/howto/docker/sharing-windows-folders-with-containers/.
To minimize the size of the Docker image the data files required by GEANT4 were not included, so you need to download them from the GEANT4 website and uncompress inside a ‘data’ directory in the shared folder: 
$ mkdir -p data 
Go to this webpage (https://geant4.web.cern.ch/node/1604) and download and uncompress all the “Data files” inside the folder you just created (you can delete the compressed versions afterwards). It's probably easier if you use graphical tools for this step.
In the end you should have something like this: 
$ pwd 
/Users/alex/docker/geant4 
$ ls data 
G4ABLA3.1 
G4ENSDFSTATE2.2 
G4NEUTRONXS1.4 
G4SAIDDATA1.1 
RadioactiveDecay5.2 
G4EMLOW7.3 
G4NDL4.5 
G4PII1.3 
PhotonEvaporation5.2 
RealSurface2.1.1 

You can now get the Docker image containing GEANT4: 
$ docker pull manuel97/geant4-qt:latest


Before starting the docker container, find out your IP address 
$ ipconfig

We are now ready to start the docker container. Make sure you are inside your shared folder: 
$ docker run -it -d --name g4image -v ${PWD}:/usershared -e DISPLAY=<Your IP here>:0 alexlindote/geant4-qt 
  
$ docker ps

Start a session inside the container with 
$ docker exec -it --user="geant4" g4image bash 
You can exit and rejoin whenever you want, and even have multiple sessions open. As long as the container is running, all the changes you make will remain in place between sessions.
Your local folder is shared under /usershared, so anything inside this folder is editable by your Mac and inside the image. This also means that changes inside this folder are permanent.
Let’s test GEANT4 using one of its examples, compile and run it: 
  
$ cp -r /usr/local/geant4/geant4.10.04.p03-install/share/Geant4-10.4.3/examples /usershared/
$ cd /usershared/examples/basic/B2/B2a
$ mkdir build
$ cd build
$ cmake ..
$ make
$ ./exampleB2a
In the Qt window that opens, type /run/beamOn 1 in the “Session” box at the bottom and press enter. You should see particle trajectories. Use the mouse to rotate, zoom in and out. If you see an error about writing permissions when trying step 1. above, exit the container and edit the setup script to uncomment the line #chmod -R a+rw . -- then source the setup script again.

That’s it! You are ready to run GEANT4 in your computer!
