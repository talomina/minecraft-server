#!/bin/bash
sudo touch /home/0.gomi
sudo apt-get update
sudo apt-get install -y default-jre-headless
sudo apt-get install wget
sudo apt-get install -y screen
sudo touch /home/1.gomi
sudo mkdir -p /home/minecraft
cd /home/minecraft
sudo wget https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar
sudo touch /home/2.gomi
sudo java -Xmx1024M -Xms1024M -jar server.jar nogui
sudo sh -c "echo eula=true > eula.txt"
sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui
sudo touch /home/9.gomi
