#!/bin/sh -e

# Add the default mods and world
if [ "${WORLD_BACKUP}" != "" ]; then
  if [ ! "$(ls -A /minecraft/world)" ]; then 
    echo "Installing default world ${WORLD_BACKUP}"
    cd /tmp && \
      wget -O world.tar.gz ${WORLD_BACKUP} && \
      tar -xzf world.tar.gz && \
      mv ./world/* /minecraft/world/ && \
      rm world.tar.gz
  fi
fi

if [ "${MODS_BACKUP}" != "" ]; then 
  if [ ! "$(ls -A /minecraft/mods)" ]; then 
    if [ ! -d "/minecraft/mods" ]; then
      mkdir /minecraft/mods
    fi

    echo "Installing default mods ${MODS_BACKUP}"
    cd /tmp && \
      wget -O mods.tar.gz ${MODS_BACKUP} && \
      tar -xzf mods.tar.gz && \
      mv ./mods/* /minecraft/mods/ && \
      rm mods.tar.gz
  fi
fi

# Configure the properties
# Echo the file as it has embedded environment variables
eval "echo \"$(cat /server.properties)\"" > /minecraft/server.properties

# Start the server
cd /minecraft
java -Xmx${JAVA_MEMORY} -Xms${JAVA_MEMORY} -jar forge-1.12.2-14.23.5.2768-universal.jar nogui