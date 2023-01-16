#!/usr/bin/env bash

data_path="${XDG_DATA_HOME:-$HOME/.local/share}"

backgrounds_path="$data_path/backgrounds"

function show_help {
	echo "Usage: $0 [-k] [-d <destination>]"
	echo ""
	echo "Options:"
	echo "	-h shows this help message"
	echo "	-k keeps the previous image"
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

response="$(curl -sL -A "WindowsShellClient/0" "https://arc.msn.com/v3/Delivery/Placement?pid=209567&fmt=json&cdm=1&lc=en,en-US&ctry=US")"
status="$?"

if [[ $status -ne 0 ]]; then
	echo "Query failed"
	exit $status
fi

item="$(jq -r ".batchrsp.items[0].item" <<<"$response")"

landscape_url="$(jq -r ".ad.image_fullscreen_001_landscape.u" <<<"$item")"
sha256="$(jq -r ".ad.image_fullscreen_001_landscape.sha256" <<<"$item" | base64 -d | hexdump -ve "1/1 \"%.2x\"")"
title="$(jq -r ".ad.title_text.tx" <<<"$item")"
search_terms="$(jq -r ".ad.title_destination_url.u" <<<"$item" | sed "s/.*q=\([^&]*\).*/\1/" | decode_url)"

mkdir -p "$backgrounds_path"
image_path="$backgrounds_path/$title ($search_terms) [$sha256].jpg"

curl -sL "$landscape_url" -o "$image_path"
sha256calculated="$(sha256sum "$image_path" | cut -d " " -f 1)"

if [[ "$sha256" != "$sha256calculated" ]]; then
	echo "Checksum incorrect"
	mv "$image_path" "$image_path.bad"
	exit 1
fi

~/bin/ksetwallpaper "$image_path"

notify-send "Background changed" "$title ($search_terms)" --app-name=spotlight --icon=preferences-desktop-wallpaper --urgency=low
echo "Background changed to $title ($search_terms)"
