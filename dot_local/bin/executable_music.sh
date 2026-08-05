#!/bin/sh

if pgrep ncmpcpp >/dev/null 2>&1; then
  echo "ncmpcpp already running"
  sleep 2
  exit
elif lsof -i 4@0.0.0.0:6601 >/dev/null 2>&1; then
  # ncmpcpp
  kitty --name ncmpcpp --title ncmpcpp -e ncmpcpp
else
  systemctl --user start mpd.service
  # ncmpcpp
  kitty --name ncmpcpp --title ncmpcpp -e ncmpcpp
fi
