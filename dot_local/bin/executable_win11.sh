#!/usr/bin/env bash

if [[ $(virsh domstate win11) == "running" ]]; then
  remote-viewer spice://localhost:5900
else
  virsh start win11
  remote-viewer spice://localhost:5900
fi
