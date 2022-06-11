# V-Rising Dedicated Server
[![Build Status](https://cloud.drone.io/api/badges/JJTC-Containers/v-rising-dedicated-server/status.svg)](https://cloud.drone.io/JJTC-Containers/v-rising-dedicated-server)

Container image for hosting V-Rising Dedicated Server.

Based on JJTC's [steam-wine-xvfb](https://github.com/jjtc-containers/v-rising-dedicated-server).
Comprised of Alpine Linux, DepotsDownloader (for getting Steam assets), Wine & Xvfb.

## Usage
For details about V-Rising Dedicated server configuration see [Stunlock Studios' V-Rising Dedicated Server Instructions)](https://github.com/StunlockStudios/vrising-dedicated-server-instructions) repository.

The game server assets will be pulled on every container startup, so to update the server simply restart the container.

If the persistentDataPath (`/home/steam/data/`) directory is empty aka no game saves or settings provided, the `entrypoint.sh` script will copy the default files into `/home/steam/data/Settings` and the game will create a new game save.

To start the image run one of the following commands:
### Podman
`podman run -d --name v-rising-dedicated-server -v /srv/v-rising-server/:/home/steam/data/:rw -e TZ=UTC -e "SERVERNAME=JJTC World" -e GAMESAVE=jjtc -e GAMEPORT=27015 -e QUERYPORT=27016 -p 27015:27015/udp -p 27016:27016/udp docker.io/jjtc/v-rising-dedicated-server:latest`

### Docker
`docker run -d --name v-rising-dedicated-server -v /srv/v-rising-server/:/home/steam/data/:rw -e TZ=UTC -e "SERVERNAME=JJTC World" -e GAMESAVE=jjtc -e GAMEPORT=27015 -e QUERYPORT=27016 -p 27015:27015/udp -p 27016:27016/udp docker.io/jjtc/v-rising-dedicated-server:latest`

### Compose
Alternatively see the `compose.yml` file for details.

```shell
git clone https://github.com/JJTC-Containers/v-rising-dedicated-server
cd v-rising-dedicated-server
docker compose pull
docker compose up -d
```

## Persistance of server file
A volume mapping can be added for `/home/steam/server/` if one wants the server files to persist.

```shell
-v /srv/v-rising-server/server:/home/steam/server/:rw
```

## persistentDataPath clarification
In the `compose.yml` example there is volume mapping from `/srv/v-rising-server/` on the host system to `/home/steam/data/` inside the container.

Running `find .` at `/srv/v-rising-server/` will reveal the following directory structure:
```shell
./v-rising-server/Saves/v1/jjtc/AutoSave_1
./v-rising-server/Saves/v1/jjtc/AutoSave_1/Header.save
./v-rising-server/Saves/v1/jjtc/AutoSave_1/SerializationJob_2.save
./v-rising-server/Saves/v1/jjtc/AutoSave_1/SerializationJob_3.save
./v-rising-server/Saves/v1/jjtc/AutoSave_1/Systems.save
./v-rising-server/Saves/v1/jjtc/AutoSave_1/SerializationJob_1.save
./v-rising-server/Saves/v1/jjtc/AutoSave_1/WorldData.save
./v-rising-server/Saves/v1/jjtc/AutoSave_1/SerializationJob_0.save
./v-rising-server/Settings
./v-rising-server/Settings/ServerHostSettings.json
./v-rising-server/Settings/ServerGameSettings.json
```

The `jjtc` part of the path is derived from the `GAMESAVE` enviromental variable.

Ensure all files in the persistentDataPath directory are owned by `10000:10001`:
```shell
cd /srv/v-rising-server/
chown 10000:10001 -R *
```
