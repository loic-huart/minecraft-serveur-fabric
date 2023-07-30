FROM openjdk:17-jdk-slim

ENV EULA=TRUE
ENV MINECRAFT_VERSION=1.20.1
ENV FABRIC_LOADER_VERSION=0.14.21
ENV FABRIC_INSTALLER_VERSION=0.11.2
ENV INIT_MEMORY='1G'
ENV MAX_MEMORY='2G'
ENV RCON_ENABLE=true
ENV RCON_PASSWORD=mypassword

RUN mkdir /app
COPY scheduled-tasks /app/scheduled-tasks

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 25565 25575

ENTRYPOINT sh /app/start.sh