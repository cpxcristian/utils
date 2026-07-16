#!/bin/bash
export PROTON_DIST_LOCK_DIR="$HOME/.proton_prefix"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/root"
export STEAM_COMPAT_DATA_PATH="$HOME/.proton_prefix"

python3 "/mnt/ddrive/SteamLibrary/steamapps/common/Proton 10.0/proton" run "/mnt/ddrive/SteamLibrary/steamapps/common/Cryptic Studios/Neverwinter.exe"
