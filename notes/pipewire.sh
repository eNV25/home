#!/bin/sh
pkill -u "$USER" -x 'pipewire|pipewire-pulse|wireplumber' 1>/dev/null 2>&1
pipewire &
pipewire-pulse &
sleep 1
exec wireplumber
