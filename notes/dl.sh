#!/bin/sh
tput civis
trap 'tput cnorm; echo' 0
/usr/bin/aria2c \
	--split=5 \
	--max-connection-per-server=5 \
	--max-concurrent-downloads=5 \
	--file-allocation=falloc \
	--remote-time=true \
	--conditional-get=true \
	--no-netrc=true \
	\
	--continue=true \
	--allow-overwrite=true \
	--always-resume=false \
	\
	--download-result=hide \
	--summary-interval=0 \
	--console-log-level=warn \
	--log-level=warn \
	"$1" -o "$2"
