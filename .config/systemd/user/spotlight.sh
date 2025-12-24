#!/usr/bin/env bash

data_path="${XDG_DATA_HOME:-$HOME/.local/share}"

backgrounds_path="$data_path/backgrounds"

function show_help {
	echo "Usage: $0 [-k] [-d <destination>]"
	echo ""
	echo "Options:"
	echo "	-h shows this help message"
	echo "	-d stores the image into the given destination. Defaults to \"$HOME/.local/share/backgrounds\"."
}

while getopts "hd:" opt; do
	case $opt in
	d)
		backgrounds_path=$OPTARG
		;;
	h | ?)
		show_help
		exit 0
		;;
	esac
done

backgrounds_path="$(realpath "$backgrounds_path")"

function decode_url {
	printf "%b\n" "$(sed 's/+/ /g; s/%\([0-9A-F][0-9A-F]\)/\\x\1/g')"
}

(
	exec {sleep}<> <(:)
	while ! : >/dev/tcp/arc.msn.com/80; do
		read -r -t 1 -u $sleep
	done
) 2>/dev/null || true

response="$(curl -sL -A "WindowsShellClient/0" "https://fd.api.iris.microsoft.com/v4/api/selection?placement=88000820&fmt=json&locale=en-IE&country=ES")"
status="$?"

if [[ $status -ne 0 ]]; then
	echo "Query failed"
	exit $status
fi

echo "$response"

landscape_url="$(jq -r ".ad.landscapeImage.asset" <<<"$response")"
title="$(jq -r ".ad.title" <<<"$response")"
description="$(jq -r ".ad.description" <<<"$response")"

mkdir -p "$backgrounds_path"
image_path="$backgrounds_path/$(basename "$landscape_url")"

"$image_path.json" <<<"$response"
curl -sL "$landscape_url" -o "$image_path"

#~/bin/ksetwallpaper "$image_path"
dms ipc wallpaper set "$image_path"

notify-send "$title" "$description" --app-name=spotlight --icon=preferences-desktop-wallpaper --urgency=low
echo "Background changed to $title"
