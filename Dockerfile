FROM openjdk:17

ENV EULA=TRUE
ENV MINECRAFT_VERSION=1.20.1
ENV FABRIC_LOADER_VERSION=0.14.21
ENV FABRIC_INSTALLER_VERSION=0.11.2
ENV INIT_MEMORY='1G'
ENV MAX_MEMORY='2G'

RUN curl -sS -o fabric-server-mc.jar https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${FABRIC_LOADER_VERSION}/${FABRIC_INSTALLER_VERSION}/server/jar
RUN chmod +x fabric-server-mc.jar

RUN mkdir /minecraft
WORKDIR /minecraft

RUN mv /fabric-server-mc.jar fabric-server-mc.jar
RUN echo "eula=${EULA}" > eula.txt

EXPOSE 25565

ENTRYPOINT java -Xms${INIT_MEMORY} -Xmx${MAX_MEMORY} -jar fabric-server-mc.jar
CMD ["nogui"]
