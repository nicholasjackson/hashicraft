#!/bin/sh

# Add the default mods and world
echo "Installing default world"
if [ ! -f /minecraft/world/level.dat ]; then 
  cd /tmp && \
    wget https://github.com/nicholasjackson/mc/releases/download/v0.0.0/world.tar.gz && \
    tar -xzf world.tar.gz && \
    mv ./world/* /minecraft/world/ && \
    rm world.tar.gz
fi

echo "Installing default mods"
if [ ! -f /minecraft/mods/mcef-1.12.2-1.11.jar ]; then 
  cd /tmp && \
    wget https://github.com/nicholasjackson/mc/releases/download/v0.0.0/mods.tar.gz && \
    tar -xzf mods.tar.gz && \
    mv ./mods/* /minecraft/mods/ && \
    rm mods.tar.gz
fi

# Configure the properties
# Echo the file as it has embedded environment variables
eval "echo \"$(cat /server.properties)\"" > /minecraft/server.properties

# Start the server
cd /minecraft
java -Xmx${JAVA_MEMORY} -Xms${JAVA_MEMORY} -jar forge-1.12.2-14.23.5.2768-universal.jar nogui