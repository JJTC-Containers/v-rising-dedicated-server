#!/bin/sh

# Create game server, settings & save data directories
mkdir -p /home/steam/server /home/steam/data/Settings "/home/steam/data/Saves/v1/$GAMESAVE"

# Get game server files
ddler -app 1829350 -os windows -dir ~/server -validate

# X11 cleanup
if [ -f /tmp/.X0-lock ]; then
  rm -r /tmp/.X0-lock
fi

cd ~/server

# Ensure the server setting files exist
if [ ! -f "/home/steam/data/Settings/ServerGameSettings.json" ]; then
  printf "ServerGameSettings.json not found! Copying default...\n"
  cp "VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json" "/home/steam/data/Settings/" || exit 1
fi

if [ ! -f "/home/steam/data/Settings/ServerHostSettings.json" ]; then
  printf "ServerHostSettings.json not found. Copying default... \n"
  cp "VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json" "/home/steam/data/Settings/" || exit 1
fi

# Start game server
printf "\nStarting game server!\n"
xvfb-run -a wine64 VRisingServer.exe -persistentDataPath ~/data -serverName "$SERVERNAME" -saveName "$GAMESAVE" -gamePort "$GAMEPORT" -queryPort "$QUERYPORT"
## Might work with wine headless build
#wine64 VRisingServer.exe -persistentDataPath ~/data -serverName "$SERVERNAME" -saveName "$GAMESAVE" -gamePort "$GAMEPORT" -queryPort "$QUERYPORT"
printf "\nShutting down game server!\n"
