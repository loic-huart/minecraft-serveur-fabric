# Minecraft Server Docker Image with Fabric

This is a Dockerfile for creating a Minecraft server that uses the Fabric modding toolchain. This Dockerfile is configured to install a specific version of Minecraft, the Fabric mod loader and Fabric installer.

## Features

- Uses OpenJDK 17 as the base image.
- Allows you to configure your server by setting environment variables for the Minecraft version, Fabric loader version, Fabric installer version, and the initial and maximum memory allocation for the Java virtual machine.
- Exposes the default Minecraft server port (25565) for connections.
- Starts the server with a no graphical user interface (GUI) option for compatibility with Docker's container model.
- Automatically accepts the EULA to save you one manual step.

## Environment Variables

| Variable | Description | Default Value |
| --- | --- | --- |
| `MINECRAFT_VERSION` | The version of Minecraft server you want to install | '1.20.1' |
| `FABRIC_LOADER_VERSION` | The version of Fabric Loader you want to install | '0.14.21' |
| `FABRIC_INSTALLER_VERSION` | The version of Fabric Installer you want to install | '0.11.2' |
| `INIT_MEMORY` | The initial amount of memory to allocate to the Java virtual machine | '1G' |
| `MAX_MEMORY` | The maximum amount of memory that can be allocated to the Java virtual machine | '2G' |
| `EULA` | Set to `TRUE` to automatically agree to the Minecraft End User License Agreement. You must agree to the EULA to run the server | `TRUE` |


## Build the Docker Image

To build this Docker image, navigate to the directory containing the Dockerfile and run the following command:

```sh
docker build -t my-minecraft-server .
```

## Run the Docker Container
To run a Docker container from this image, use the following command:
```sh
docker run -p 25565:25565 -d my-minecraft-server
```

This will start a Minecraft server with the Fabric mod loader running on your local machine, accessible on port 25565.

## Note
Please make sure to check the EULA before setting EULA to TRUE. By setting EULA to TRUE, you are indicating your agreement to the EULA.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.