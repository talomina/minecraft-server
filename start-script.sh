#!/bin/bash
sudo apt-get update
sudo apt-get install -y default-jre-headless
sudo apt-get install wget
sudo apt-get install -y screen

sudo mkdir -p /home/minecraft
cd /home/minecraft
sudo wget https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar
sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui
