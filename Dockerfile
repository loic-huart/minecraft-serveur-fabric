FROM openjdk:17-jdk-buster

ENV EULA=TRUE
ENV MINECRAFT_VERSION=1.20.1
ENV FABRIC_LOADER_VERSION=0.14.21
ENV FABRIC_INSTALLER_VERSION=0.11.2
ENV INIT_MEMORY='1G'
ENV MAX_MEMORY='2G'
ENV RCON_ENABLE=true
ENV RCON_PASSWORD=mypassword

RUN apt-get update && apt-get install -y cron nodejs npm jq

RUN curl -sS -o fabric-server-mc.jar https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${FABRIC_LOADER_VERSION}/${FABRIC_INSTALLER_VERSION}/server/jar
RUN chmod +x fabric-server-mc.jar

RUN mkdir /minecraft
WORKDIR /minecraft

RUN mv /fabric-server-mc.jar fabric-server-mc.jar
RUN echo "eula=${EULA}" > eula.txt

RUN echo "enable-rcon=${RCON_ENABLE}" > server.properties
RUN echo "rcon.password=${RCON_PASSWORD}" >> server.properties
RUN echo "rcon.port=25575" >> server.properties

COPY scheduled-tasks scheduled-tasks
RUN npm install rcon

EXPOSE 25565 25575

COPY start.sh start.sh
RUN chmod +x start.sh

ENTRYPOINT sh start.sh
