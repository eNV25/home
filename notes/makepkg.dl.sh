#!/bin/sh
{
	/usr/bin/aria2c \
		--split=5 \
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
		-UWget \
		"$1" -o "$2"
} && {
	tput cr el
}
