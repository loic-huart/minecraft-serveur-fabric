# Minecraft Server Docker Image with Fabric

This is a Dockerfile for creating a Minecraft server that uses the Fabric modding toolchain. This Dockerfile is configured to install a specific version of Minecraft, the Fabric mod loader and Fabric installer.

## Features

- Uses OpenJDK 17 as the base image.
- Allows you to configure your server by setting environment variables for the Minecraft version, Fabric loader version, Fabric installer version, and the initial and maximum memory allocation for the Java virtual machine.
- Exposes the default Minecraft server port (25565) for connections.
- Starts the server with a no graphical user interface (GUI) option for compatibility with Docker's container model.
- Automatically accepts the EULA to save you one manual step.
- RCON is enabled for remote command execution, with the password set via environment variable.
- Includes a cron job setup for scheduling tasks such as automated restarts.

## Environment Variables

| Variable | Description | Default Value |
| --- | --- | --- |
| `MINECRAFT_VERSION` | The version of Minecraft server you want to install | '1.20.1' |
| `FABRIC_LOADER_VERSION` | The version of Fabric Loader you want to install | '0.14.21' |
| `FABRIC_INSTALLER_VERSION` | The version of Fabric Installer you want to install | '0.11.2' |
| `INIT_MEMORY` | The initial amount of memory to allocate to the Java virtual machine | '1G' |
| `MAX_MEMORY` | The maximum amount of memory that can be allocated to the Java virtual machine | '2G' |
| `EULA` | Set to `TRUE` to automatically agree to the Minecraft End User License Agreement. You must agree to the EULA to run the server | `TRUE` |
| `RCON_ENABLE`| Set to `TRUE` to enable the RCON protocol for remote command execution | `TRUE` |
| `RCON_PASSWORD` | The password for the RCON protocol. Change this to a strong, unique password before enabling RCON | 'mypassword' |

## Scheduled Tasks and Automated Restarts

This Docker image includes a cron job setup which allows you to schedule tasks such as automated restarts. To use this feature, the RCON protocol must be enabled by setting RCON_ENABLE to TRUE and setting RCON_PASSWORD to a strong, unique password.

Tasks are configured in the /scheduled-tasks/tasks.conf.json file. A default task is included that counts down before restarting the server.

To add more tasks, you can modify the tasks.conf.json file. Here is the format to follow:

```json
{
  "restart": {
    "cron": "0 0 * * *",
    "tasks": [
      { "time": 60000, "command": "say The server will restart in 5 minutes."  },
      { "time": 60000, "command": "say 4 minutes left before server restart." },
      { "time": 60000, "command": "say 3 minutes left before server restart." },
      { "time": 60000, "command": "say 2 minutes left before server restart." },
      { "time": 30000, "command": "say 1 minute left before server restart." },
      { "time": 15000, "command": "say 30 seconds left before server restart." },
      { "time": 10000, "command": "say 15 seconds left before server restart." },
      { "time": 1000, "command": "say 5 seconds left before server restart." },
      { "time": 1000, "command": "say 4 seconds left before server restart." },
      { "time": 1000, "command": "say 3 seconds left before server restart." },
      { "time": 1000, "command": "say 2 seconds left before server restart." },
      { "time": 1000, "command": "say 1 second left before server restart." },
      { "time": 1000, "command": "say The server will restart now." },
      { "time": 1000, "command": "stop" }
    ]
  }
}
```

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

## Running the Docker Container with docker-compose
To run the services related to the Minecraft server using docker-compose, please follow these steps:

- Make sure you have Docker Compose installed and working on your system.
- Place the [`docker-compose.yml`](./docker-compose.yml) file in a directory of your choice.

- Open a command prompt or terminal, navigate to the directory containing the [`docker-compose.yml`](./docker-compose.yml) file, and run the following command:

```sh
docker-compose up -d
```

This will start the services specified in the docker-compose.yml, including the Minecraft server with Fabric and the Filebrowser service.

Make sure you have the necessary permissions to run Docker and Docker Compose.

To stop the services, you can use the following command:
```sh
docker-compose down
```

## Note
Please make sure to check the EULA before setting EULA to TRUE. By setting EULA to TRUE, you are indicating your agreement to the EULA.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.