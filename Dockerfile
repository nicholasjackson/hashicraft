FROM java:8-jdk

WORKDIR /minecraft

# Install rcon
RUN wget https://github.com/itzg/rcon-cli/releases/download/1.4.7/rcon-cli_1.4.7_linux_amd64.tar.gz && \
  tar -xzf rcon-cli_1.4.7_linux_amd64.tar.gz && \
  rm rcon-cli_1.4.7_linux_amd64.tar.gz && \
  mv rcon-cli /usr/local/bin


RUN echo "Tokens $github_token"

# Setup the server
RUN wget https://github.com/nicholasjackson/mc/releases/download/v0.0.0/forge-1.12.2-14.23.5.2768-installer.tar.gz && \
  tar -xzf forge-1.12.2-14.23.5.2768-installer.tar.gz && \
  rm forge-1.12.2-14.23.5.2768-installer.tar.gz && \
  java -jar forge-1.12.2-14.23.5.2768-installer.jar --installServer

# Copy the signed eula
COPY ./eula.txt eula.txt

# Add the entrypoint
COPY ./entrypoint.sh /minecraft/entrypoint.sh

ENV JAVA_MEMORY 1G

ENTRYPOINT [ "/minecraft/entrypoint.sh" ]